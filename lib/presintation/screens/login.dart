import 'dart:ui';

import 'package:bashkatep/presintation/screens/superAdmin/dashboardScreen.dart';
import 'package:bashkatep/presintation/screens/superAdmin/superAdmin_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:bashkatep/core/bloc/auth_cubit/auth_login_cubit.dart';
import 'package:bashkatep/presintation/screens/admin_screen.dart';
import 'package:bashkatep/presintation/widgets/custom_text_field.dart';
import 'package:bashkatep/core/utils/validation/validator.dart';
import 'package:bashkatep/presintation/screens/home_screen.dart'; // Assuming you have a HomeScreen
import 'package:bashkatep/utilies/constans.dart';
import 'package:mesh_gradient/mesh_gradient.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key, this.name});
  final String? name;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final height = size.height;
    final width = size.width;
    final cubit = context.read<AuthLoginCubit>();

    return Scaffold(
      backgroundColor: Colors.transparent,
      resizeToAvoidBottomInset: true,
      body: AnimatedMeshGradient(
        colors: [
          Colors.redAccent,
          Colors.blue,
          AppColors.colorGreen,
          AppColors.colorLight
        ],
        options: AnimatedMeshGradientOptions(),
        child: BlocListener<AuthLoginCubit, AuthLoginState>(
          listener: (context, state) async {
            if (state is AuthLoginFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            } else if (state is AuthLoginSuccess) {
              try {
                // Ensure Hive boxes are opened
                if (!Hive.isBoxOpen('userRole')) {
                  await Hive.openBox('userRole');
                }

                final box = Hive.box('userRole');
                final clientBox = Hive.box('clientId');
                final clientId = clientBox.get('clientId');
                final role = box.get('userRole');

                // if (role == null || role.isEmpty) {
                //   debugPrint('Role is null or empty');
                //   ScaffoldMessenger.of(context).showSnackBar(
                //     SnackBar(
                //         content: Text('An error occurred: role is missing.')),
                //   );
                //   return;
                // }

                debugPrint('Navigating with role: $role');

                if (role == 'admin' ||
                    state.isSuperAdmin == false && state.isAdmin == true) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AdminScreen(
                              clientId: clientId,
                            )),
                  );
                  debugPrint(" Admin");
                } else if (role == 'super_admin' ||
                    state.isSuperAdmin == true && state.isAdmin == false) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const DashboardScreen()),
                  );
                  debugPrint("Super Admin");
                } else {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => HomeScreen()),
                  );
                  debugPrint(" Worker");
                }
              } catch (e) {
                debugPrint('Error handling login success: $e');
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Text('An error occurred while logging in.')),
                );
              }
            }
          },
          child: BlocBuilder<AuthLoginCubit, AuthLoginState>(
            builder: (context, state) {
              if (state is AuthLoginLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              return Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(25)),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(
                      sigmaX: 100,
                      sigmaY: 100,
                    ),
                    child: Container(
                      width: width * 0.6,
                      height: height * 0.8,
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.15),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(25),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(22.0),
                        child: Center(
                          child: Form(
                            key: cubit.formKey,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Text(
                                  "تسجيل الدخول",
                                  style: TextStyle(
                                    fontSize: 42,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                                SizedBox(height: height * 0.1),
                                CustomTextField(
                                  width: width * 0.4,
                                  height: height * 0.065,
                                  prefixIcon: Icons.person_rounded,
                                  hintText: 'ادخل اسم المستخدم',
                                  keyboardType: TextInputType.text,
                                  obscureText: false,
                                  validator: Validator().validateName,
                                  controller: cubit.userController,
                                ),
                                SizedBox(height: height * 0.02),
                                CustomTextField(
                                  width: width * 0.4,
                                  height: height * 0.065,
                                  prefixIcon: Icons.lock,
                                  hintText: 'ادخل كلمة السر',
                                  keyboardType: TextInputType.text,
                                  obscureText: false,
                                  validator: Validator().validatePassword,
                                  controller: cubit.passwordController,
                                ),
                                SizedBox(height: height * 0.06),
                                ElevatedButton(
                                  onPressed: () async {
                                    if (cubit.formKey.currentState!
                                        .validate()) {
                                      await cubit.login(
                                        cubit.userController.text,
                                        cubit.passwordController.text,
                                        context,
                                      );
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        AppColors.colorGreen.withOpacity(0.6),
                                    fixedSize:
                                        Size(width * 0.4, height * 0.065),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: const Text(
                                    "تــســجــيــل الــدخــول",
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
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
