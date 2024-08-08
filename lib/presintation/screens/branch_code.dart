import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:bashkatep/core/bloc/attend_cubit/qr_cubit.dart';
import 'package:bashkatep/core/utils/validation/validator.dart';
import 'package:bashkatep/presintation/screens/home_screen.dart';
import 'package:bashkatep/presintation/widgets/custom_text_field.dart';
import 'package:bashkatep/utilies/constans.dart';

class BranchCode extends StatelessWidget {
  final bool isCheckIn;

  const BranchCode({super.key, required this.isCheckIn});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final height = size.height;
    final width = size.width;
    final cubit = context.read<QRScanCubit>();

    final boxToken = Hive.box('token');
    final boxName = Hive.box('userName');
    final String id = boxToken.get('token', defaultValue: 'default_token');
    final String userName =
        boxName.get('userName', defaultValue: 'default_user');

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => BlocProvider(
                  create: (context) => QRScanCubit(),
                  child: const HomeScreen(),
                ),
              ),
            );
          },
        ),
      ),
      body: BlocBuilder<QRScanCubit, QRScanState>(
        builder: (context, state) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: width * 0.8,
                  child: CustomTextField(
                    controller: cubit.controller,
                    prefixIcon: Icons.person_rounded,
                    hintText: 'ادخل كود الفرع',
                    keyboardType: TextInputType.number,
                    obscureText: false,
                    validator: Validator().validateName,
                  ),
                ),
                SizedBox(height: height * 0.1),
                ElevatedButton(
                  onPressed: () async {
                    String branchCode = cubit.controller.text;
                    debugPrint(id);
                    if (isCheckIn) {
                      cubit.checkBranchCode(branchCode, id, userName, context);
                    } else {
                      cubit.checkBranchCodeCheckOut(branchCode, context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.colorGreen,
                    fixedSize: Size(width * 0.7, height * 0.07),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    isCheckIn ? "تسجيل حضور" : "تسجيل انصراف",
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                SizedBox(height: height * 0.05),
                if (state is QRScanLoading)
                  const CircularProgressIndicator()
                else if (state is QRScanSuccess)
                  Column(
                    children: [
                      Text('فرع : ${state.result.name}'),
                    ],
                  )
                else if (state is QRScanFailure)
                  Text(state.error)
                else
                  const SizedBox(),
              ],
            ),
          );
        },
      ),
    );
  }
}
