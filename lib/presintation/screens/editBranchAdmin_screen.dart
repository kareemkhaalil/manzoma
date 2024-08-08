import 'package:bashkatep/core/models/branches_model.dart';
import 'package:bashkatep/presintation/screens/superAdmin/clients_viewScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bashkatep/core/bloc/super_admin/superAdmin_cubit.dart';
import 'package:bashkatep/utilies/constans.dart';
import 'package:bashkatep/presintation/screens/admin_screen.dart';

class EditBranchScreenAdmin extends StatelessWidget {
  final BranchModel branch;
  final String clientId;

  EditBranchScreenAdmin({required this.branch, required this.clientId});

  @override
  Widget build(BuildContext context) {
    final _nameController = TextEditingController(text: branch.name);
    final _managerIdController = TextEditingController(text: branch.managerId);
    final _qrCodeController = TextEditingController(text: branch.qrCode);
    final _latitudeController =
        TextEditingController(text: branch.location.latitude.toString());
    final _longitudeController =
        TextEditingController(text: branch.location.longitude.toString());

    return Scaffold(
      appBar: AppBar(
        title: Text('تعديل الفرع'),
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
              const SnackBar(content: Text('تم تعديل الفرع بنجاح')),
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
                        labelText: 'اسم الفرع',
                      ),
                    ),
                    TextFormField(
                      controller: _managerIdController,
                      decoration: InputDecoration(
                        labelText: 'رقم هوية المدير',
                      ),
                    ),
                    TextFormField(
                      controller: _qrCodeController,
                      decoration: InputDecoration(
                        labelText: 'رمز الاستجابة السريعة',
                      ),
                    ),
                    TextFormField(
                      controller: _latitudeController,
                      decoration: InputDecoration(
                        labelText: 'خطوط العرض',
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    TextFormField(
                      controller: _longitudeController,
                      decoration: InputDecoration(
                        labelText: 'خطوط الطول',
                      ),
                      keyboardType: TextInputType.number,
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
                        final updatedBranch = branch.copyWith(
                          branchId: branch.branchId,
                          name: _nameController.text,
                          managerId: _managerIdController.text,
                          qrCode: _qrCodeController.text,
                          location: GeoPoint(
                            double.parse(_latitudeController.text),
                            double.parse(_longitudeController.text),
                          ),
                        );

                        context
                            .read<SuperAdminCubit>()
                            .updateBranch(clientId, updatedBranch);
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
                        final updatedBranch = branch.copyWith(
                          branchId: branch.branchId,
                          name: _nameController.text,
                          managerId: _managerIdController.text,
                          qrCode: _qrCodeController.text,
                          location: GeoPoint(
                            double.parse(_latitudeController.text),
                            double.parse(_longitudeController.text),
                          ),
                        );

                        if (clientId.isEmpty || branch.branchId.isEmpty) {
                          debugPrint('Client ID: $clientId');
                          debugPrint('Employee ID: ${branch.branchId}');

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text(
                                    'Client ID or Admin Employee ID is empty.')),
                          );
                          return;
                        }

                        context
                            .read<SuperAdminCubit>()
                            .deleteBranchWithConfirmation(
                              context,
                              clientId,
                              branch.branchId,
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
