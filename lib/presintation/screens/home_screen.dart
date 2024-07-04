import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hudor/core/bloc/attend_cubit/qr_cubit.dart';
import 'package:hudor/presintation/screens/branch_code.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final height = size.height;
    final width = size.width;
    final box = Hive.box('userName');
    final token = box.get('userName');
    var value = Hive.box<bool>('isAttend').get('isAttend') ?? false;
    var lastAttendanceTime =
        Hive.box<DateTime>('lastAttendanceTime').get('lastAttendanceTime');

    // Calculate the difference in hours
    var hoursDifference = lastAttendanceTime != null
        ? DateTime.now().difference(lastAttendanceTime).inHours
        : null;
    bool canEnableButtons = hoursDifference == null || hoursDifference >= 12;

    return BlocBuilder<QRScanCubit, QRScanState>(
      builder: (context, state) {
        return Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
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
                      backgroundColor: const Color(0xff3ED9A0),
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
                      backgroundColor: const Color(0xff3ED9A0),
                      fixedSize: Size(width * 0.7, height * 0.07),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      "انــــــــصــــــــراف",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  )
              ],
            ),
          ),
        );
      },
    );
  }
}
