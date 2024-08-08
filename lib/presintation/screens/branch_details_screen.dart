import 'package:flutter/material.dart';
import 'package:bashkatep/core/models/branches_model.dart'; // Replace with your attendance model

class BranchDetailsScreen extends StatelessWidget {
  final BranchModel branch;

  const BranchDetailsScreen({super.key, required this.branch});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Attendance Details - ${branch.name}',
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Branch ID: ${branch.branchId}',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            // Implement your attendance data display here
          ],
        ),
      ),
    );
  }
}
