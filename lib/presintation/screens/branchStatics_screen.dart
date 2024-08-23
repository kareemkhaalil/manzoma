import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bashkatep/core/bloc/attend_cubit/attendance_cubit.dart';
import 'package:bashkatep/core/models/branches_model.dart';
import 'package:bashkatep/presintation/screens/attendanceDataTable_screen.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:bashkatep/core/models/attendance_model.dart';
import 'package:bashkatep/presintation/screens/editBranchAdmin_screen.dart';
import 'package:bashkatep/presintation/screens/admin_screen.dart';

class BranchStatisticsScreen extends StatelessWidget {
  const BranchStatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AttendanceCubit>();
    final clientBox = Hive.box('clientId');
    final clientId = clientBox.get('clientId');

    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text('إحصائيات الفروع'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AdminScreen(
                  clientId: clientId,
                ),
              ),
            );
          },
        ),
      ),
      body: Center(
        child: FutureBuilder<List<BranchModel>>(
          future: cubit.fetchBranches(clientId),
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
                          builder: (context) => AttendanceDataTableScreen(
                            branchId: branch.branchId,
                            clientId: clientId,
                          ),
                        ),
                      );
                    },
                    child: FutureBuilder<List<AttendanceRecordModel>>(
                      future: cubit.fetchBranchAttendanceDataForToday(
                          clientId, branch.branchId),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else if (!snapshot.hasData ||
                            snapshot.data!.isEmpty) {
                          return Card(
                            elevation: 3,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(children: [
                                    Text(
                                      branch.name,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Spacer(),
                                    IconButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                EditBranchScreenAdmin(
                                              clientId: clientId,
                                              branch: branch,
                                            ),
                                          ),
                                        );
                                      },
                                      icon: Icon(
                                        Icons.edit,
                                      ),
                                    ),
                                  ]),
                                  const SizedBox(height: 10),
                                  Text(
                                    'Branch ID: ${branch.branchId}',
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                  const SizedBox(height: 10),
                                  const Text(
                                    'No attendance data available.',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ],
                              ),
                            ),
                          );
                        } else {
                          List<AttendanceRecordModel> attendanceData =
                              snapshot.data!;
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      AttendanceDataTableScreen(
                                    branchId: branch.branchId,
                                    clientId: clientId,
                                  ),
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
                                    Row(children: [
                                      Text(
                                        branch.name,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Spacer(),
                                      IconButton(
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  EditBranchScreenAdmin(
                                                clientId: clientId,
                                                branch: branch,
                                              ),
                                            ),
                                          );
                                        },
                                        icon: Icon(
                                          Icons.edit,
                                        ),
                                      ),
                                    ]),
                                    const SizedBox(height: 10),
                                    Text(
                                      'كود الفرع : ${branch.qrCode}',
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      'كل عمليات التسجيل: ${attendanceData.length}',
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                    Text(
                                      'آخر تسجيل دخول: ${attendanceData.last.employeeName}',
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }
                      },
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
