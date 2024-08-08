import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bashkatep/core/bloc/admin/add_user_cubit/add_user_cubit.dart';
import 'package:bashkatep/core/utils/validation/validator.dart';
import 'package:bashkatep/presintation/screens/admin_screen.dart';
import 'package:bashkatep/presintation/widgets/custom_text_field.dart';
import 'package:bashkatep/utilies/constans.dart';
import 'package:hive_flutter/hive_flutter.dart';

class AddUserScreen extends StatelessWidget {
  const AddUserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final height = size.height;
    final width = size.width;
    final cubit = context.read<AuthAddUserCubit>();
    final clientBox = Hive.box('clientId');
    final clientId = clientBox.get('clientId');

    return Scaffold(
      appBar: AppBar(
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
      resizeToAvoidBottomInset: true,
      body: BlocListener<AuthAddUserCubit, AuthAddUserState>(
        listener: (context, state) {
          if (state is AuthAddUserFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          } else if (state is AuthAddUserSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('تم إضافة المستخدم بنجاح')),
            );
          }
        },
        child: BlocBuilder<AuthAddUserCubit, AuthAddUserState>(
          builder: (context, state) {
            if (state is AuthAddUserLoading) {
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
                        "إضافة مستخدم جديد",
                        style: TextStyle(
                          fontSize: 38,
                          color: AppColors.colorGreen,
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
                        controller: cubit.nameController,
                      ),
                      SizedBox(height: height * 0.02),
                      CustomTextField(
                        width: width * 0.9,
                        height: height * 0.065,
                        prefixIcon: Icons.email,
                        hintText: 'ادخل البريد الإلكتروني',
                        keyboardType: TextInputType.emailAddress,
                        obscureText: false,
                        validator: Validator().validateEmail,
                        controller: cubit.emailController,
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
                      SizedBox(height: height * 0.02),
                      CustomTextField(
                        width: width * 0.9,
                        height: height * 0.065,
                        prefixIcon: Icons.person,
                        hintText: 'ادخل اسم المستخدم للعرض',
                        keyboardType: TextInputType.text,
                        obscureText: false,
                        validator: Validator().validateName,
                        controller: cubit.userNameController,
                      ),
                      SizedBox(height: height * 0.02),
                      SizedBox(
                        width: width * 0.9,
                        child: DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                            labelText: 'اختر الدور',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          items: ['admin', 'user'].map((role) {
                            return DropdownMenuItem(
                              value: role,
                              child: Text(role),
                            );
                          }).toList(),
                          onChanged: (value) {
                            cubit.selectedRole = value;
                          },
                          validator: (value) =>
                              value == null ? 'اختر الدور' : null,
                        ),
                      ),
                      SizedBox(height: height * 0.06),
                      ElevatedButton(
                        onPressed: () async {
                          if (cubit.formKey.currentState!.validate()) {
                            await cubit.addUser(
                                cubit.nameController.text,
                                cubit.emailController.text,
                                cubit.passwordController.text,
                                cubit.userNameController.text,
                                cubit.selectedRole ?? '',
                                clientId);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.colorGreen,
                          fixedSize: Size(width * 0.9, height * 0.065),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          "إضافة المستخدم",
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
