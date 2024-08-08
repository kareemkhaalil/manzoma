import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bashkatep/core/bloc/super_admin/superAdmin_cubit.dart';
import 'package:bashkatep/core/models/client_model.dart';

class AddClientScreen extends StatelessWidget {
  AddClientScreen({Key? key}) : super(key: key);

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _clientNameController = TextEditingController();
  final TextEditingController _maxAdminsController = TextEditingController();
  final TextEditingController _maxUsersController = TextEditingController();
  final TextEditingController _maxBranchesController = TextEditingController();
  final TextEditingController _branchCostController = TextEditingController();
  final TextEditingController _userCostController = TextEditingController();
  final TextEditingController _adminCostController = TextEditingController();

  void _addClient(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      final cubit = context.read<SuperAdminCubit>();

      final client = ClientModel(
        clientId: '',
        clientName: _clientNameController.text,
        admins: [], // No admins added initially
        users: [], // No users added initially
        branches: [], // No branches added initially
        attendanceRecords: [], // Initialize as empty
        maxAdmins: int.parse(_maxAdminsController.text),
        maxUsers: int.parse(_maxUsersController.text),
        maxBranches: int.parse(_maxBranchesController.text),
        userCost: double.parse(_userCostController.text),
        adminCost: double.parse(_adminCostController.text),
        branchCost: double.parse(_branchCostController.text),
        isSuspended: false, // Default value
      );

      cubit.addClient(client);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return BlocBuilder<SuperAdminCubit, SuperAdminState>(
      builder: (context, state) {
        if (state is SuperAdminAddClientLoading) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  SizedBox(
                      width: 50,
                      height: 50,
                      child: CircularProgressIndicator()),
                  SizedBox(height: 20),
                  Text('Adding client in progress...',
                      style: TextStyle(fontSize: 18)),
                ],
              ),
            ),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text('Add Client'),
          ),
          body: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Client Information',
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold)),
                    SizedBox(height: height * 0.02),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _clientNameController,
                            decoration:
                                const InputDecoration(labelText: 'Client Name'),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter client name';
                              }
                              return null;
                            },
                          ),
                        ),
                        SizedBox(width: width * 0.02),
                        Expanded(
                          child: TextFormField(
                            controller: _maxAdminsController,
                            decoration:
                                const InputDecoration(labelText: 'Max Admins'),
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter max admins';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: height * 0.02),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _maxUsersController,
                            decoration:
                                const InputDecoration(labelText: 'Max Users'),
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter max users';
                              }
                              return null;
                            },
                          ),
                        ),
                        SizedBox(width: width * 0.02),
                        Expanded(
                          child: TextFormField(
                            controller: _maxBranchesController,
                            decoration: const InputDecoration(
                                labelText: 'Max Branches'),
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter max branches';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: height * 0.02),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _branchCostController,
                            decoration:
                                const InputDecoration(labelText: 'Branch Cost'),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        SizedBox(width: width * 0.02),
                        Expanded(
                          child: TextFormField(
                            controller: _userCostController,
                            decoration:
                                const InputDecoration(labelText: 'User Cost'),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: height * 0.02),
                    TextFormField(
                      controller: _adminCostController,
                      decoration:
                          const InputDecoration(labelText: 'Admin Cost'),
                      keyboardType: TextInputType.number,
                    ),
                    SizedBox(height: height * 0.02),
                    ElevatedButton(
                      onPressed: () => _addClient(context),
                      child: const Text('Add Client'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
