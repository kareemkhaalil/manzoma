import 'package:bashkatep/core/bloc/attend_cubit/attendance_cubit.dart';
import 'package:bashkatep/presintation/screens/add_brach_screen.dart';
import 'package:bashkatep/presintation/screens/add_user_screen.dart';
import 'package:bashkatep/presintation/screens/branchStatics_screen.dart';
import 'package:bashkatep/presintation/screens/user_report_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fl_chart/fl_chart.dart';

class AdminScreen extends StatelessWidget {
  final String? name;
  final String clientId;

  const AdminScreen({super.key, this.name, required this.clientId});

  @override
  Widget build(BuildContext context) {
    // Assume you have a Cubit or Bloc for state management
    final cubit = context.read<AttendanceCubit>();
    final Size size = MediaQuery.of(context).size;

    return BlocProvider(
      create: (context) => cubit..fetchClientData(clientId),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('لوحة الإدارة'),
          backgroundColor: Colors.blueAccent,
          elevation: 0,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (name != null)
                Container(
                  padding: const EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                    color: Colors.blueAccent,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'مــرحــبا',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            name!,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 38,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ],
                      ),
                      const CircleAvatar(
                        radius: 30,
                        backgroundImage: AssetImage('assets/avatar.png'),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 20),
              BlocBuilder<AttendanceCubit, AttendanceState>(
                builder: (context, state) {
                  if (state is AttendanceLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is AttendanceClientDataLoaded) {
                    final clientData = state.clientData;
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildMetricCard(
                            'عدد المستخدمين',
                            '${clientData.users.length}',
                            'عدد المستخدمين الحاليين'),
                        _buildMetricCard(
                            'جلسات الحضور والانصراف',
                            '${clientData.attendanceRecords.length}',
                            'عدد جلسات الحضور والانصراف'),
                        _buildMetricCard(
                            'عدد الفروع',
                            '${clientData.branches.length}',
                            'عدد الفروع الحالي'),
                      ],
                    );
                  } else if (state is AttendanceFailure) {
                    return Text('حدث خطأ: ${state.error}');
                  }
                  return Container();
                },
              ),
              const SizedBox(height: 20),
              BlocBuilder<AttendanceCubit, AttendanceState>(
                builder: (context, state) {
                  if (state is AttendanceLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is AttendanceClientDataLoaded) {
                    final clientData = state.clientData;
                    final totalUsers = clientData.users.length;
                    final totalBranches = clientData.branches.length;
                    final totalAttendance = clientData.attendanceRecords.length;

                    return SizedBox(
                      height: 300,
                      child: BarChart(
                        BarChartData(
                          alignment: BarChartAlignment.spaceAround,
                          maxY: totalAttendance.toDouble(),
                          barTouchData: BarTouchData(
                            touchTooltipData: BarTouchTooltipData(
                              getTooltipColor: (BarChartGroupData group) =>
                                  Colors
                                      .blueAccent, // Make sure this is correct
                            ),
                            touchCallback: (FlTouchEvent event,
                                BarTouchResponse? response) {},
                            handleBuiltInTouches: true,
                          ),
                          titlesData: FlTitlesData(
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 40,
                                getTitlesWidget: (value, meta) {
                                  return SideTitleWidget(
                                    axisSide: meta.axisSide,
                                    child: Text(
                                      value.toInt().toString(),
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blueAccent,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 40,
                                getTitlesWidget: (value, meta) {
                                  String title;
                                  switch (value.toInt()) {
                                    case 0:
                                      title = 'الحضور';
                                      break;
                                    case 1:
                                      title = 'المستخدمين';
                                      break;
                                    case 2:
                                      title = 'الفروع';
                                      break;
                                    default:
                                      title = '';
                                      break;
                                  }
                                  return SideTitleWidget(
                                    axisSide: meta.axisSide,
                                    child: Text(
                                      title,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blueAccent,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                          borderData: FlBorderData(
                            show: true,
                            border: Border.all(
                              color: const Color(0xff37434d),
                              width: 1,
                            ),
                          ),
                          barGroups: [
                            BarChartGroupData(
                              x: 0,
                              barRods: [
                                BarChartRodData(
                                  toY: totalAttendance.toDouble(),
                                  color: Colors.blueAccent,
                                ),
                              ],
                            ),
                            BarChartGroupData(
                              x: 1,
                              barRods: [
                                BarChartRodData(
                                  toY: totalUsers.toDouble(),
                                  color: Colors.orangeAccent,
                                ),
                              ],
                            ),
                            BarChartGroupData(
                              x: 2,
                              barRods: [
                                BarChartRodData(
                                  toY: totalBranches.toDouble(),
                                  color: Colors.greenAccent,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  } else if (state is AttendanceFailure) {
                    return Text('حدث خطأ: ${state.error}');
                  }
                  return Container();
                },
              ),
              const SizedBox(height: 20),
              GridView.count(
                shrinkWrap: true,
                crossAxisCount: size.width > 600 ? 5 : 2,
                crossAxisSpacing: 30.0,
                mainAxisSpacing: 10.0,
                children: [
                  _buildElevatedButton(
                    context,
                    Icons.add_business,
                    'إضافة فرع',
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AddBranchScreen(),
                        ),
                      );
                    },
                  ),
                  _buildElevatedButton(
                    context,
                    Icons.person_add,
                    'إضافة مستخدم',
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AddUserScreen(),
                        ),
                      );
                    },
                  ),
                  _buildElevatedButton(
                    context,
                    Icons.business,
                    'تقارير الفروع',
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const BranchStatisticsScreen(),
                        ),
                      );
                    },
                  ),
                  _buildElevatedButton(
                    context,
                    Icons.business,
                    'تقارير المستخدمين',
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              UserReportsScreen(clientId: clientId),
                        ),
                      );
                    },
                  ),
                  BlocBuilder<AttendanceCubit, AttendanceState>(
                    builder: (context, state) {
                      if (state is AttendanceLoading) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (state is AttendanceFailure) {
                        return Text('حدث خطأ: ${state.error}');
                      }
                      return _buildElevatedButton(
                        context,
                        Icons.file_download,
                        "تحميل بيانات الحضور",
                        () {
                          cubit.exportAttendance(context, clientId);
                        },
                      );
                    },
                  )
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMetricCard(String title, String value, String subtitle) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16.0),
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 3,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              value,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              subtitle,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildElevatedButton(BuildContext context, IconData icon, String label,
      VoidCallback onPressed) {
    final Size size = MediaQuery.of(context).size;

    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blueAccent,
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        minimumSize: Size(size.width * 0.1, size.width * 0.05),
        fixedSize: Size(size.width * 0.2, size.width * 0.1),
        maximumSize: Size(size.width * 0.5, size.width * 0.2),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.white),
          const SizedBox(height: 8.0),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
