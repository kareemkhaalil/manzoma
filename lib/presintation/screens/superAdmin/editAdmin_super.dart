import 'package:bashkatep/core/models/user_model.dart';
import 'package:bashkatep/presintation/screens/superAdmin/clients_viewScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bashkatep/core/bloc/super_admin/superAdmin_cubit.dart';
import 'package:bashkatep/utilies/constans.dart';

class EditAdminScreen extends StatelessWidget {
  final UserModel admin;
  final String clientId;
  final String employeeId;

  EditAdminScreen(
      {required this.admin, required this.clientId, required this.employeeId});

  @override
  Widget build(BuildContext context) {
    final _nameController = TextEditingController(text: admin.name);
    final _emailController = TextEditingController(text: admin.email);
    final _usernameController = TextEditingController(text: admin.userName);
    final _passwordController = TextEditingController(text: admin.password);

    return Scaffold(
      appBar: AppBar(
        title: Text('تعديل الأدمن'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ClientsViewScreen(),
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
              const SnackBar(content: Text('تم إضافة الفرع بنجاح')),
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
                  crossAxisCount: 4,
                  shrinkWrap: true,
                  mainAxisSpacing: 1.0,
                  crossAxisSpacing: 1.0,
                  childAspectRatio: 4,
                  children: [
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: 'اسم الأدمن',
                      ),
                    ),
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: 'البريد الإلكتروني',
                      ),
                    ),
                    TextFormField(
                      controller: _usernameController,
                      decoration: InputDecoration(
                        labelText: 'اسم المستخدم',
                      ),
                    ),
                    TextFormField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        labelText: 'كلمة المرور',
                      ),
                      obscureText: true,
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.colorGreen, // لون الخلفية
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(10.0), // الزوايا المدورة
                        ),
                        padding:
                            EdgeInsets.all(12), // المسافة بين النص وحدود الزر
                      ),
                      onPressed: () {
                        final updatedAdmin = admin.copyWith(
                          name: _nameController.text,
                          email: _emailController.text,
                          employeeId: employeeId.toString(),
                          userName: _usernameController.text,
                          password: _passwordController.text,
                        );

                        if (clientId.isEmpty || employeeId.isEmpty) {
                          debugPrint('Client ID: $clientId');
                          debugPrint('Employee ID: ${employeeId}');

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text(
                                    'Client ID or Admin Employee ID is empty.')),
                          );
                          return;
                        }

                        context
                            .read<SuperAdminCubit>()
                            .updateAdmin(clientId, updatedAdmin);
                      },
                      child: Text(
                        'حفظ التعديلات',
                        style: TextStyle(
                          color: Colors.white, // لون النص
                          fontSize: 16,
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
                        final updatedAdmin = admin.copyWith(
                          name: _nameController.text,
                          email: _emailController.text,
                          employeeId: employeeId.toString(),
                          userName: _usernameController.text,
                          password: _passwordController.text,
                        );

                        if (clientId.isEmpty || employeeId.isEmpty) {
                          debugPrint('Client ID: $clientId');
                          debugPrint('Employee ID: ${employeeId}');

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text(
                                    'Client ID or Admin Employee ID is empty.')),
                          );
                          return;
                        }

                        context
                            .read<SuperAdminCubit>()
                            .deleteAdminWithConfirmation(
                              context,
                              clientId,
                              employeeId,
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
