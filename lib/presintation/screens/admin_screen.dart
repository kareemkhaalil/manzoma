import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hudor/core/bloc/attend_cubit/attendance_cubit.dart';
import 'package:hudor/core/models/branches_model.dart';
import 'package:hudor/presintation/screens/add_brach_screen.dart';
import 'package:hudor/presintation/screens/add_user_screen.dart';
import 'package:hudor/presintation/screens/attendanceDataTable_screen.dart';
import 'package:hudor/presintation/screens/branchStatics_screen.dart';
import 'package:hudor/presintation/screens/userStatics_screen.dart';

class AdminScreen extends StatelessWidget {
  final String? name;

  const AdminScreen({super.key, this.name});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AttendanceCubit>(); // Correct usage

    final Size size = MediaQuery.of(context).size;

    return BlocProvider(
      create: (context) => cubit, // Correct usage
      child: Scaffold(
        appBar: AppBar(
          title: const Text('لوحة الإدارة'),
        ),
        body: ListView(
          padding: const EdgeInsets.all(20.0),
          children: [
            if (name != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'مــرحــبا',
                    style: TextStyle(
                      fontSize: 20,
                      color: Color(0xff3ED9A0),
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  Text(
                    name!,
                    style: const TextStyle(
                      fontSize: 38,
                      color: Color(0xff3ED9A0),
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            GridView.count(
              shrinkWrap: true,
              crossAxisCount: size.width > 600 ? 3 : 2,
              crossAxisSpacing: 20.0,
              mainAxisSpacing: 20.0,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AddBranchScreen(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff3ED9A0),
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    "إضافة فرع",
                    style: TextStyle(
                      fontSize: size.width * 0.01,
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AddUserScreen(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff3ED9A0),
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    "إضافة مستخدم",
                    style: TextStyle(
                      fontSize: size.width * 0.01,
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const BranchStatisticsScreen(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff3ED9A0),
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    "إحصائيات الفروع",
                    style: TextStyle(
                      fontSize: size.width * 0.01,
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => const UserStatisticsScreen(),
                    //   ),
                    // );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff3ED9A0),
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    "إحصائيات المستخدمين",
                    style: TextStyle(
                      fontSize: size.width * 0.01,
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            BlocBuilder<AttendanceCubit, AttendanceState>(
              builder: (context, state) {
                if (state is AttendanceLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is AttendanceSuccess) {
                  return Column(
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          final snackBar = SnackBar(
                            content: Text(
                              'تم حفظ الملف في: ${state.filePath}',
                            ),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xff3ED9A0),
                          padding: const EdgeInsets.symmetric(vertical: 20.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          "تصدير بيانات الحضور",
                          style: TextStyle(
                            fontSize: size.width * 0.01,
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'تم التصدير بنجاح! المسار: ${state.filePath}',
                      ),
                    ],
                  );
                }
                if (state is AttendanceFailure) {
                  return Text('حدث خطأ: ${state.error}');
                }
                return ElevatedButton(
                  onPressed: () async {
                    cubit.exportAttendance(context); // Using cubit directly
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff3ED9A0),
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    "تصدير بيانات الحضور",
                    style: TextStyle(
                      fontSize: size.width * 0.01,
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
