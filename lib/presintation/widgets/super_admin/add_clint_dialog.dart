import 'package:bashkatep/core/bloc/super_admin/superAdmin_cubit.dart';
import 'package:bashkatep/core/models/client_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddClientDialog extends StatefulWidget {
  const AddClientDialog({Key? key}) : super(key: key);

  @override
  _AddClientDialogState createState() => _AddClientDialogState();
}

class _AddClientDialogState extends State<AddClientDialog> {
  final _formKey = GlobalKey<FormState>();
  final _clientNameController = TextEditingController();
  final _maxAdminsController = TextEditingController();
  final _maxUsersController = TextEditingController();
  final _maxBranchesController = TextEditingController();
  final _branchCostController = TextEditingController();

  final _userCostController = TextEditingController();

  final _adminCostController = TextEditingController();

  @override
  void dispose() {
    _clientNameController.dispose();
    _maxAdminsController.dispose();
    _maxUsersController.dispose();
    _maxBranchesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Client'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _clientNameController,
                decoration: const InputDecoration(labelText: 'Client Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the client name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _maxAdminsController,
                decoration: const InputDecoration(labelText: 'Max Admins'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the max admins';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _maxUsersController,
                decoration: const InputDecoration(labelText: 'Max Users'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the max users';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _maxBranchesController,
                decoration: const InputDecoration(labelText: 'Max Branches'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the max branches';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              final client = ClientModel(
                clientId: '', // ID will be assigned by Firestore
                clientName: _clientNameController.text,
                admins: [], // Empty list initially
                users: [], // Empty list initially
                branches: [], // Empty list initially
                maxAdmins: int.parse(_maxAdminsController.text),
                maxUsers: int.parse(_maxUsersController.text),
                maxBranches: int.parse(_maxBranchesController.text),
                userCost: _userCostController as double,
                adminCost: _adminCostController as double,
                branchCost: _branchCostController as double,
                isSuspended: false, attendanceRecords: [],
              );

              context.read<SuperAdminCubit>().addClient(client);
              Navigator.of(context).pop();
            }
          },
          child: const Text('Add'),
        ),
      ],
    );
  }
}
