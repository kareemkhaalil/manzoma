import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hudor/core/bloc/auth_cubit/auth_login_cubit.dart';
import 'package:hudor/presintation/screens/admin_screen.dart';
import 'package:hudor/presintation/widgets/custom_text_field.dart';
import 'package:hudor/core/utils/validation/validator.dart';
import 'package:hudor/presintation/screens/home_screen.dart'; // Assuming you have a HomeScreen
import 'package:hudor/presintation/screens/superAdmin_screen.dart';

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
      resizeToAvoidBottomInset: true,
      body: BlocListener<AuthLoginCubit, AuthLoginState>(
        listener: (context, state) async {
          if (state is AuthLoginFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          } else if (state is AuthLoginSuccess) {
            final box = Hive.box('userRole');
            final String role = box.get('userRole') ??
                'worker'; // Default to 'worker' if role not found
            if (role == 'admin') {
              await Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const AdminScreen()),
              );
            } else if (role == 'super_admin') {
              await Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        const SuperAdminScreen()), // Navigate to SuperAdminScreen
              );
            } else {
              await Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const HomeScreen()),
              );
            }
          }
        },
        child: BlocBuilder<AuthLoginCubit, AuthLoginState>(
          builder: (context, state) {
            if (state is AuthLoginLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            return Padding(
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
                          fontSize: 38,
                          color: Color(0xff3ED9A0),
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      SizedBox(height: height * 0.1),
                      CustomTextField(
                        width: width * 0.9,
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
                        width: width * 0.9,
                        height: height * 0.065,
                        prefixIcon: Icons.lock,
                        hintText: 'ادخل كلمة السر',
                        keyboardType: TextInputType.text,
                        obscureText: true,
                        validator: Validator().validatePassword,
                        controller: cubit.passwordController,
                      ),
                      SizedBox(height: height * 0.06),
                      ElevatedButton(
                        onPressed: () async {
                          if (cubit.formKey.currentState!.validate()) {
                            await cubit.login(
                              cubit.userController.text,
                              cubit.passwordController.text,
                              context,
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xff3ED9A0),
                          fixedSize: Size(width * 0.9, height * 0.065),
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
            );
          },
        ),
      ),
    );
  }
}
