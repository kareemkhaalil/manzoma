import 'package:flutter/material.dart';
import 'package:manzoma/core/entities/user_entity.dart';

class EmployeeProfileScreen extends StatelessWidget {
  final UserEntity user;

  const EmployeeProfileScreen({required this.user, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('البروفايل')),
      body: Center(
        child: Text('بروفايل ${user.name} (قيد التطوير)'),
      ),
    );
  }
}
