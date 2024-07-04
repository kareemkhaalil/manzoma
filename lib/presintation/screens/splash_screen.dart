import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hudor/core/bloc/form_validator/form_validator_cubit.dart';
import 'package:hudor/presintation/screens/home_screen.dart';
import 'package:hudor/presintation/screens/login.dart';
import 'package:hudor/presintation/screens/admin_screen.dart';
import 'package:hudor/presintation/screens/superAdmin_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Future<Map<String, dynamic>> _loadData() async {
    await Future.delayed(const Duration(seconds: 2));
    var tokenBox = await Hive.openBox('token');
    var roleBox = await Hive.openBox('userRole');
    var nameBox = await Hive.openBox('userName');
    String? name = nameBox.get('userName');
    String? token = tokenBox.get('token');
    String? role = roleBox.get('userRole');

    return {
      'name': name,
      'token': token,
      'role': role,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: FutureBuilder<Map<String, dynamic>>(
          future: _loadData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'فهيم',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff3ED9A0),
                    ),
                  ),
                  SizedBox(height: 20),
                  CircularProgressIndicator(),
                ],
              );
            } else if (snapshot.hasError) {
              return const Text('Error loading data');
            } else {
              final data = snapshot.data!;
              final String? name = data['name'];
              final String? token = data['token'];
              final String? role = data['role'];

              if (token != null && token.isNotEmpty) {
                // Navigate to appropriate screen based on user role
                if (role == 'admin') {
                  return AdminScreen(name: name);
                } else if (role == 'super_admin') {
                  return const SuperAdminScreen(); // Navigate to SuperAdminScreen
                } else {
                  return const HomeScreen();
                }
              } else {
                // Navigate to LoginScreen if token does not exist
                return BlocProvider<FormValidatorCubit>(
                  create: (context) => FormValidatorCubit(),
                  child: LoginScreen(name: name),
                );
              }
            }
          },
        ),
      ),
    );
  }
}
