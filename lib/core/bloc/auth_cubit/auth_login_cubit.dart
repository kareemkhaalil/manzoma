import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:bashkatep/core/models/client_model.dart';

part 'auth_login_state.dart';

class AuthLoginCubit extends Cubit<AuthLoginState> {
  final Box tokenBox;
  final Box nameBox;
  final Box roleBox;
  final Box clientId;

  AuthLoginCubit(
    this.tokenBox,
    this.nameBox,
    this.roleBox,
    this.clientId,
  ) : super(AuthLoginInitial());

  final TextEditingController userController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  Future<void> login(
      String username, String password, BuildContext context) async {
    try {
      emit(AuthLoginLoading());

      String? email;
      String? userRole;

      // Query to get super admins
      QuerySnapshot superAdminSnapshot = await _firestore
          .collection('super_admins')
          .where('userName', isEqualTo: username)
          .limit(1)
          .get();

      if (superAdminSnapshot.docs.isNotEmpty) {
        var superAdmin = superAdminSnapshot.docs.first;
        if (superAdmin['pass'] == password) {
          email = superAdmin['email'];
          userRole = superAdmin['role'];
          await roleBox.put('userRole', userRole);
          debugPrint("Hive role (super_admin): ${roleBox.get('userRole')}");
        } else {
          emit(const AuthLoginFailure('Invalid password.'));
          return;
        }
      }

      if (email == null) {
        // Query to get all clients
        QuerySnapshot clientSnapshots =
            await _firestore.collection('clients').get();

        bool userFound = false;

        for (var clientSnapshot in clientSnapshots.docs) {
          ClientModel client = ClientModel.fromJson(
              clientSnapshot.data() as Map<String, dynamic>, clientSnapshot.id);

          // Search in admins
          for (var admin in client.admins) {
            if (admin.userName == username && admin.password == password) {
              email = admin.email;
              userRole = admin.role;
              await clientId.put('clientId', client.clientId.toString());
              await roleBox.put('userRole', userRole);
              userFound = true;
              break;
            }
          }

          if (userFound) break;

          // Search in users
          for (var user in client.users) {
            if (user.userName == username && user.password == password) {
              email = user.email;
              userRole = user.role;
              await clientId.put('clientId', client.clientId.toString());

              await roleBox.put('userRole', userRole);
              userFound = true;
              debugPrint('is User : ${user.role}  ${user.name}');
              break;
            }
          }

          if (userFound) break;
        }

        if (!userFound) {
          emit(const AuthLoginFailure('User not found.'));
          return;
        }
      }

      UserCredential userCredential =
          await _firebaseAuth.signInWithEmailAndPassword(
        email: email!,
        password: password,
      );

      await nameBox.put('userName', username);
      await tokenBox.put('token', userCredential.user!.uid);
      final client = await clientId.get('clientId');

      debugPrint("userRole after login: ${roleBox.get('userRole')}");
      debugPrint('client id ' + client);

      if (userRole == 'super_admin') {
        emit(const AuthLoginSuccess(isAdmin: false, isSuperAdmin: true));
      } else if (userRole == 'admin') {
        emit(const AuthLoginSuccess(isAdmin: true, isSuperAdmin: false));
      } else {
        emit(const AuthLoginSuccess(isAdmin: false, isSuperAdmin: false));
      }
    } on FirebaseAuthException catch (e) {
      emit(AuthLoginFailure('FirebaseAuth error: ${e.message}'));
    } catch (e) {
      emit(AuthLoginFailure('An unexpected error occurred: $e'));
    }
  }

  refresh() {
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
