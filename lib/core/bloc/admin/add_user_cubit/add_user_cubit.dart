import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:bashkatep/core/helpers/firebase_helper/auth_helper.dart';
import 'package:bashkatep/core/helpers/firebase_helper/firestore_helper.dart';
import 'package:bashkatep/core/models/user_model.dart';

part 'add_user_state.dart';

class AuthAddUserCubit extends Cubit<AuthAddUserState> {
  AuthAddUserCubit() : super(AuthAddUserInitial());

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController userNameController = TextEditingController();
  String? selectedRole;
  String? clientId; // Add clientId here
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirestoreHelper _firestoreHelper = FirestoreHelper();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  Future<void> addUser(String name, String email, String password,
      String userName, String role, clientId) async {
    try {
      emit(AuthAddUserLoading());

      // Create a new user with Firebase Auth
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      String uid = userCredential.user!.uid;

      // Create a new user model
      UserModel newUser = UserModel(
        name: name,
        email: email,
        password: password,
        userName: userName,
        role: role,
        employeeId: uid,
      );

      // Add user data to client's users subcollection
      await _firestoreHelper.addUserToClient(clientId!, newUser);

      emit(AuthAddUserSuccess());
    } catch (e) {
      emit(AuthAddUserFailure('حدث خطأ أثناء إضافة المستخدم: $e'));
    }
  }
}
