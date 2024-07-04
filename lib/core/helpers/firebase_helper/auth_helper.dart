import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hudor/core/helpers/firebase_helper/firestore_helper.dart';
import 'package:hudor/core/models/user_model.dart';
import 'package:hudor/core/repos/hive_repo/hive_repo.dart';
import 'package:hudor/core/repos/hive_repo/hive_repo_impl.dart';

class FirebaseAuthHelper {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirestoreHelper _firestoreHelper = FirestoreHelper();
  final HiveRepo hiveRepo = HiveRepoImpl(Hive.box('token'));

  Future<UserCredential?> signInWithUsernameAndPassword(
      String username, String password) async {
    try {
      debugPrint('sign in user pass');
      // 1. Search for the user by username in the database
      debugPrint('get all');
      QuerySnapshot querySnapshot =
          await _firestoreHelper.getAllDocuments('users');

      // Find the user with the entered username
      debugPrint('find user ');
      var userDoc = querySnapshot.docs.firstWhere(
        (doc) => doc['userName'] == username,
        orElse: () => throw Exception('User not found'),
      );
      debugPrint('success find user name $username');
      debugPrint('success find user pass $password');

      debugPrint('user doc ${userDoc.data()}');

      // Convert the document to a UserModel
      UserModel user = UserModel.fromJson(
          userDoc.data() as Map<String, dynamic>, userDoc.id);

      // Debug prints to verify data
      debugPrint('Found user: $user');
      debugPrint('Stored password: ${user.password}');
      debugPrint('Entered password: $password');

      // 2. Verify the password
      if (user.password != password) {
        debugPrint('Incorrect password');
        return null;
      }
      debugPrint('sign in email pass ');
      debugPrint('email ${user.email}');
      await hiveRepo.put('token', user.employeeId);
      await hiveRepo.put('userName', user.name);
      await hiveRepo.put('userRole', user.role); // Store user role
      final role = hiveRepo.get('userRole');
      debugPrint('role $role');

      // 3. Sign in using FirebaseAuth
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: user.email, password: password);

      debugPrint("auth helper ${userCredential.user!.uid.toString()}");
      return userCredential;
    } catch (e) {
      debugPrint("Error during sign-in with username: $e");
      return null;
    }
  }

  Future<String?> fetchUserRoleFromDatabase(String? userId) async {
    try {
      // Replace 'users' with your collection name in Firestore
      DocumentSnapshot docSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      // Extract user role from document
      String userRole = docSnapshot[
          'role']; // Replace 'role' with your field name for user role

      return userRole;
    } on FirebaseException catch (e) {
      print('Error fetching user role: $e');
      // Handle error appropriately, e.g., return a default role or re-throw the exception
      return 'worker'; // Default to 'worker' role if there's an error
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      debugPrint("Error signing out: $e");
    }
  }

  // Get current user
  User? getCurrentUser() {
    return _auth.currentUser;
  }
}
