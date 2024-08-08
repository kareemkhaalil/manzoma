import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:bashkatep/core/bloc/attend_cubit/qr_cubit.dart';
import 'package:bashkatep/presintation/screens/branch_code.dart';
import 'package:bashkatep/utilies/constans.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final height = size.height;
    final width = size.width;

    return FutureBuilder(
      future: Future.wait([
        Future.value(Hive.box<bool>('isAttend')),
        Hive.isBoxOpen('lastAttendanceTime')
            ? Future.value(Hive.box<DateTime>('lastAttendanceTime'))
            : Hive.openBox<DateTime>('lastAttendanceTime'),
        Hive.isBoxOpen('clientId')
            ? Future.value(Hive.box('clientId'))
            : Hive.openBox('clientId')
      ]),
      builder: (context, AsyncSnapshot<List<Box>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (snapshot.hasData) {
          final isAttendBox = snapshot.data![0] as Box<bool>;
          final lastAttendanceTimeBox = snapshot.data![1] as Box<DateTime>;
          final clientIdBox = snapshot.data![2];

          final box = Hive.box('userName');
          final token = box.get('userName');
          final clientId = clientIdBox.get('clientId');
          var value = isAttendBox.get('isAttend') ?? false;
          var lastAttendanceTime =
              lastAttendanceTimeBox.get('lastAttendanceTime');

          // حساب الفرق بالساعات
          var hoursDifference = lastAttendanceTime != null
              ? DateTime.now().difference(lastAttendanceTime).inHours
              : null;
          bool canEnableButtons =
              hoursDifference == null || hoursDifference >= 12;

          return BlocBuilder<QRScanCubit, QRScanState>(
            builder: (context, state) {
              return Scaffold(
                body: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      FutureBuilder<String?>(
                        future: BlocProvider.of<QRScanCubit>(context)
                            .getClientName(clientId),
                        builder: (context, AsyncSnapshot<String?> snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const CircularProgressIndicator();
                          } else if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          } else if (snapshot.hasData) {
                            return Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    "مرحبا ",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w200,
                                      color: Colors.blueAccent,
                                    ),
                                  ),
                                  SizedBox(
                                    height: height * 0.02,
                                  ),
                                  Text(
                                    snapshot.data!,
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w900,
                                      color: Colors.blueAccent,
                                    ),
                                  ),
                                ]);
                          } else {
                            return const Text('Client name not found');
                          }
                        },
                      ),
                      SizedBox(height: height * 0.1),
                      value != null
                          ? Text(
                              value ? 'تم تسجيل الحضور ' : 'تم تسجل انصراف',
                              style: const TextStyle(fontSize: 18),
                            )
                          : SizedBox(
                              width: width * 0.0001,
                            ),
                      SizedBox(
                        height: height * 0.1,
                      ),
                      if (value == false)
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BlocProvider.value(
                                  value: BlocProvider.of<QRScanCubit>(context),
                                  child: const BranchCode(isCheckIn: true),
                                ),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.colorGreen,
                            fixedSize: Size(width * 0.7, height * 0.07),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            "حـــــضــــــور",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                      SizedBox(
                        height: height * 0.1,
                      ),
                      if (value == true)
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BlocProvider.value(
                                  value: BlocProvider.of<QRScanCubit>(context),
                                  child: const BranchCode(isCheckIn: false),
                                ),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.colorGreen,
                            fixedSize: Size(width * 0.7, height * 0.07),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            "انصراف",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          );
        }

        return const Center(child: Text('Unexpected error'));
      },
    );
  }
}
