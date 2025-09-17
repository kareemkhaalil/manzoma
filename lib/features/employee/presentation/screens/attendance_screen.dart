import 'package:flutter/material.dart';

class AttendanceEmployeeScreen extends StatelessWidget {
  const AttendanceEmployeeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("سجل الحضور")),
      body: const Center(
        child: Text("هنا هيظهر جدول الحضور"),
      ),
    );
  }
}
