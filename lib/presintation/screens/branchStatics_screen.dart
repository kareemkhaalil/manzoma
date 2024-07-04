import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hudor/core/bloc/attend_cubit/attendance_cubit.dart';
import 'package:hudor/core/models/branches_model.dart';
import 'package:hudor/presintation/screens/attendanceDataTable_screen.dart';

class BranchStatisticsScreen extends StatefulWidget {
  const BranchStatisticsScreen({
    super.key,
  });

  @override
  State<BranchStatisticsScreen> createState() => _BranchStatisticsScreenState();
}

class _BranchStatisticsScreenState extends State<BranchStatisticsScreen> {
  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AttendanceCubit>(); // Correct usage

    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text('إحصائيات الفروع'),
      ),
      body: Center(
        child: FutureBuilder<List<BranchModel>>(
          future: cubit.fetchBranches(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No data found.'));
            } else {
              List<BranchModel> branches = snapshot.data!;
              return GridView.count(
                shrinkWrap: true,
                crossAxisCount: size.width > 600 ? 3 : 2,
                crossAxisSpacing: 20.0,
                mainAxisSpacing: 20.0,
                children: branches.map((branch) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              AttendanceDataTableScreen(branchId: branch.id),
                        ),
                      );
                    },
                    child: Card(
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              branch.name,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'Branch ID: ${branch.id}',
                              style: const TextStyle(fontSize: 16),
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              'Tap to view attendance data',
                              style: TextStyle(color: Colors.blue),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              );
            }
          },
        ),
      ),
    );
  }
}
