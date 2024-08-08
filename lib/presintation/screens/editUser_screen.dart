import 'package:bashkatep/core/models/branches_model.dart';
import 'package:bashkatep/presintation/screens/superAdmin/clients_viewScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bashkatep/core/bloc/super_admin/superAdmin_cubit.dart';
import 'package:bashkatep/utilies/constans.dart';
import 'package:bashkatep/presintation/screens/admin_screen.dart';
import 'package:bashkatep/core/models/user_model.dart';

class EditUserScreenAdmin extends StatelessWidget {
  final UserModel user;
  final String clientId;

  EditUserScreenAdmin({required this.user, required this.clientId});

  @override
  Widget build(BuildContext context) {
    final _nameController = TextEditingController(text: user.name);
    final _roleController = TextEditingController(text: user.role);
    final _passwordController = TextEditingController(text: user.password);
    final _userNameController = TextEditingController(text: user.userName);
    final _emailController = TextEditingController(text: user.email);

    return Scaffold(
      appBar: AppBar(
        title: Text('تعديل المستخدم'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AdminScreen(clientId: clientId),
              ),
            );
          },
        ),
      ),
      body: BlocListener<SuperAdminCubit, SuperAdminState>(
        listener: (context, state) {
          if (state is SuperAdminError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error)),
            );
            debugPrint(state.error);
          } else if (state is SuperAdminOperationSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('تم تعديل المستخدم بنجاح')),
            );
          }
        },
        child: BlocBuilder<SuperAdminCubit, SuperAdminState>(
          builder: (context, state) {
            if (state is SuperAdminLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            return Padding(
              padding: EdgeInsets.all(8.0),
              child: Form(
                child: GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  mainAxisSpacing: 1.0,
                  crossAxisSpacing: 1.0,
                  childAspectRatio: 4,
                  children: [
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: 'اسم المستخدم',
                      ),
                    ),
                    TextFormField(
                      controller: _roleController,
                      decoration: InputDecoration(
                        labelText: 'الدور',
                      ),
                    ),
                    TextFormField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        labelText: 'كلمة المرور',
                      ),
                    ),
                    TextFormField(
                      controller: _userNameController,
                      decoration: InputDecoration(
                        labelText: 'اسم المستخدم',
                      ),
                    ),
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: 'البريد الإلكتروني',
                      ),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        fixedSize: Size.fromHeight(50),
                        backgroundColor: AppColors.colorGreen, // لون الخلفية
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(10.0), // الزوايا المدورة
                        ),
                        padding:
                            EdgeInsets.all(12), // المسافة بين النص وحدود الزر
                      ),
                      onPressed: () {
                        final updatedUser = user.copyWith(
                          name: _nameController.text,
                          role: _roleController.text,
                          password: _passwordController.text,
                          userName: _userNameController.text,
                          email: _emailController.text,
                        );

                        context
                            .read<SuperAdminCubit>()
                            .updateUser(clientId, updatedUser);
                      },
                      child: Center(
                        child: Text(
                          'حفظ التعديلات',
                          style: TextStyle(
                            color: Colors.white, // لون النص
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            Color.fromARGB(255, 235, 55, 55), // لون الخلفية
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(10.0), // الزوايا المدورة
                        ),
                        padding:
                            EdgeInsets.all(12), // المسافة بين النص وحدود الزر
                      ),
                      onPressed: () {
                        final updatedUser = user.copyWith(
                          name: _nameController.text,
                          role: _roleController.text,
                          password: _passwordController.text,
                          userName: _userNameController.text,
                          email: _emailController.text,
                        );

                        if (clientId.isEmpty || user.employeeId.isEmpty) {
                          debugPrint('Client ID: $clientId');
                          debugPrint('User ID: ${user.employeeId}');

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content:
                                    Text('Client ID or User ID is empty.')),
                          );
                          return;
                        }

                        context
                            .read<SuperAdminCubit>()
                            .deleteUserWithConfirmation(
                              context,
                              clientId,
                              user.employeeId,
                            );
                      },
                      child: Text(
                        'حذف',
                        style: TextStyle(
                          color: Colors.white, // لون النص
                          fontSize: 16,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
