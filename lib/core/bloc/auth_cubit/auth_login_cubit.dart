import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hudor/core/helpers/firebase_helper/auth_helper.dart';
import 'package:hudor/core/helpers/firebase_helper/firestore_helper.dart';
import 'package:hudor/core/models/user_model.dart';

part 'auth_login_state.dart';

class AuthLoginCubit extends Cubit<AuthLoginState> {
  final Box tokenBox;
  final Box nameBox;
  final Box attendanceRecordIdBox;
  final Box roleBox; // Add role box

  AuthLoginCubit(
      this.tokenBox, this.nameBox, this.attendanceRecordIdBox, this.roleBox)
      : super(AuthLoginInitial());

  final TextEditingController userController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FirebaseAuthHelper firebase = FirebaseAuthHelper();
  final FirestoreHelper _firestoreHelper = FirestoreHelper();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  Future<void> login(String name, String password, BuildContext context) async {
    try {
      emit(AuthLoginLoading());

      var result = await firebase.signInWithUsernameAndPassword(name, password);
      debugPrint("auth login cubit = $result");

      if (result != null) {
        // Store user name and token in Hive
        await nameBox.put('userName', name);
        debugPrint("auth login cubit name = $name");

        await tokenBox.put('token', result.user!.uid);
        QuerySnapshot querySnapshot =
            await _firestoreHelper.getAllDocuments('users');
        var userDoc = querySnapshot.docs.firstWhere(
          (doc) => doc['userName'] == name,
          orElse: () => throw Exception('User not found'),
        );

        // Retrieve and store the user role
        final userRole =
            userDoc['role']; // Use this line to fetch role directly
        await roleBox.put('userRole', userRole);
        debugPrint('User role: $userRole');

        if (userRole == 'admin') {
          emit(const AuthLoginSuccess(isAdmin: true));
        } else {
          emit(const AuthLoginSuccess(isAdmin: false));
        }
        debugPrint('success login');
      } else {
        emit(
          const AuthLoginFailure(
              'تسجيل الدخول فشل. تحقق من اسم المستخدم وكلمة المرور.'),
        );
      }
    } on FirebaseException catch (e) {
      emit(AuthLoginFailure('خطأ في تسجيل الدخول: ${e.message}'));
      print('Firebase error: ${e.message}');
    } catch (e) {
      emit(AuthLoginFailure('حدث خطأ غير متوقع: $e'));
      print('Unexpected error: $e');
    }
  }

  void refresh() {
    emit(AuthLoginInitial());
  }

  void showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void validateName(String name) async {
    if (name.isEmpty) {
      emit(const AuthLoginValidationError("ادخل اسم المستخدم"));
    } else {
      emit(AuthLoginValid());
    }
  }

  void validatePassword(String password) async {
    if (password.isEmpty) {
      emit(const AuthLoginValidationError("ادخل كلمة السر"));
    } else {
      emit(AuthLoginValid());
    }
  }
}
