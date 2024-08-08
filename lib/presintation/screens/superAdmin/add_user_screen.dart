import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bashkatep/core/bloc/super_admin/superAdmin_cubit.dart';
import 'package:bashkatep/core/models/user_model.dart';

class AddUserScreenS extends StatelessWidget {
  final String clientId;

  AddUserScreenS({required this.clientId});

  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _userEmailController = TextEditingController();
  final TextEditingController _userPasswordController = TextEditingController();

  void _addUser(BuildContext context) {
    if (_userNameController.text.isNotEmpty &&
        _userEmailController.text.isNotEmpty &&
        _userPasswordController.text.isNotEmpty) {
      final user = UserModel(
        employeeId: '',
        name: _userNameController.text,
        role: 'user',
        password: _userPasswordController.text,
        userName: _userNameController.text,
        email: _userEmailController.text,
      );
      context.read<SuperAdminCubit>().addUser(clientId, user);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add New User'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _userNameController,
              decoration: InputDecoration(labelText: 'User Name'),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _userEmailController,
              decoration: InputDecoration(labelText: 'User Email'),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _userPasswordController,
              decoration: InputDecoration(labelText: 'User Password'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _addUser(context),
              child: Text('Add User'),
            ),
          ],
        ),
      ),
    );
  }
}
