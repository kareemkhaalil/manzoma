import 'package:bashkatep/core/helpers/firebase_helper/firestore_helper.dart';
import 'package:bashkatep/presintation/screens/add_brach_screen.dart';
import 'package:bashkatep/presintation/screens/add_user_screen.dart';
import 'package:bashkatep/presintation/screens/superAdmin/add_brach_screen_super.dart';
import 'package:bashkatep/presintation/screens/superAdmin/add_user_screen_super.dart';
import 'package:bashkatep/presintation/screens/superAdmin/editAdmin_super.dart';
import 'package:bashkatep/presintation/screens/superAdmin/editBranch_super.dart';

import 'package:bashkatep/utilies/constans.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bashkatep/core/bloc/super_admin/superAdmin_cubit.dart';
import 'package:bashkatep/core/models/client_model.dart';
import 'add_user_screen.dart';

class ClientDetailScreen extends StatelessWidget {
  final String clientId;

  ClientDetailScreen({required this.clientId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          SuperAdminCubit(firestoreHelper: FirestoreHelper())..getClients(),
      child: ClientDetailView(clientId: clientId),
    );
  }
}

class ClientDetailView extends StatelessWidget {
  final String clientId;

  ClientDetailView({required this.clientId});

  @override
  Widget build(BuildContext context) {
    // Fetch the client data based on the clientId
    final client = context
        .watch<SuperAdminCubit>()
        .clients
        .firstWhere((c) => c.clientId == clientId);

    final _nameController = TextEditingController(text: client.clientName);
    final _adminsController =
        TextEditingController(text: client.admins.length.toString());
    final _adminCostController =
        TextEditingController(text: client.adminCost.toString());
    final _usersController =
        TextEditingController(text: client.users.length.toString());
    final _userCostController =
        TextEditingController(text: client.userCost.toString());
    final _branchesController =
        TextEditingController(text: client.branches.length.toString());
    final _branchCostController =
        TextEditingController(text: client.branchCost.toString());
    final _totalCostController = TextEditingController(
        text: (client.adminCost + client.userCost + client.branchCost)
            .toString());
    final _maxAdminsController =
        TextEditingController(text: client.maxAdmins.toString());
    final _maxUsersController =
        TextEditingController(text: client.maxUsers.toString());
    final _maxBranchesController =
        TextEditingController(text: client.maxBranches.toString());

    return Scaffold(
      appBar: AppBar(
        title: Text(client.clientName),
      ),
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: BlocBuilder<SuperAdminCubit, SuperAdminState>(
          builder: (context, state) {
            bool _isEditing = state is SuperAdminEditingClient;
            final size = MediaQuery.of(context).size;

            return LayoutBuilder(
              builder: (context, constraints) {
                bool isLargeScreen = constraints.maxWidth > 1200;

                double fontSize = isLargeScreen ? 18 : 14;
                double padding = isLargeScreen ? 4.0 : 8.0;
                double blurRadius = isLargeScreen ? 2.0 : 4.0;

                return SingleChildScrollView(
                  child: Form(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.all(padding),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: blurRadius,
                                spreadRadius: 1.0,
                                offset: Offset(1.0, 1.0),
                              ),
                            ],
                          ),
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
                                  labelText: 'Name',
                                  labelStyle: TextStyle(fontSize: fontSize),
                                ),
                                enabled: _isEditing,
                              ),
                              TextFormField(
                                controller: _adminsController,
                                decoration: InputDecoration(
                                  labelText: 'Admins',
                                  labelStyle: TextStyle(fontSize: fontSize),
                                ),
                                enabled: _isEditing,
                              ),
                              TextFormField(
                                controller: _adminCostController,
                                decoration: InputDecoration(
                                  labelText: 'Admin Costs',
                                  labelStyle: TextStyle(fontSize: fontSize),
                                ),
                                enabled: _isEditing,
                              ),
                              TextFormField(
                                controller: _usersController,
                                decoration: InputDecoration(
                                  labelText: 'Users',
                                  labelStyle: TextStyle(fontSize: fontSize),
                                ),
                                enabled: _isEditing,
                              ),
                              TextFormField(
                                controller: _userCostController,
                                decoration: InputDecoration(
                                  labelText: 'User Costs',
                                  labelStyle: TextStyle(fontSize: fontSize),
                                ),
                                enabled: _isEditing,
                              ),
                              TextFormField(
                                controller: _branchesController,
                                decoration: InputDecoration(
                                  labelText: 'Branches',
                                  labelStyle: TextStyle(fontSize: fontSize),
                                ),
                                enabled: _isEditing,
                              ),
                              TextFormField(
                                controller: _branchCostController,
                                decoration: InputDecoration(
                                  labelText: 'Branch Costs',
                                  labelStyle: TextStyle(fontSize: fontSize),
                                ),
                                enabled: _isEditing,
                              ),
                              TextFormField(
                                controller: _totalCostController,
                                decoration: InputDecoration(
                                  labelText: 'Total Costs',
                                  labelStyle: TextStyle(fontSize: fontSize),
                                ),
                                enabled: _isEditing,
                              ),
                              TextFormField(
                                controller: _maxAdminsController,
                                decoration: InputDecoration(
                                  labelText: 'Max Admins',
                                  labelStyle: TextStyle(fontSize: fontSize),
                                ),
                                enabled: _isEditing,
                              ),
                              TextFormField(
                                controller: _maxUsersController,
                                decoration: InputDecoration(
                                  labelText: 'Max Users',
                                  labelStyle: TextStyle(fontSize: fontSize),
                                ),
                                enabled: _isEditing,
                              ),
                              TextFormField(
                                controller: _maxBranchesController,
                                decoration: InputDecoration(
                                  labelText: 'Max Branches',
                                  labelStyle: TextStyle(fontSize: fontSize),
                                ),
                                enabled: _isEditing,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 20),
                        _isEditing
                            ? ElevatedButton(
                                onPressed: () {
                                  final updatedClient = client.copyWith(
                                    clientName: _nameController.text,
                                    maxAdmins:
                                        int.parse(_maxAdminsController.text),
                                    maxUsers:
                                        int.parse(_maxUsersController.text),
                                    maxBranches:
                                        int.parse(_maxBranchesController.text),
                                    adminCost:
                                        double.parse(_adminCostController.text),
                                    userCost:
                                        double.parse(_userCostController.text),
                                    branchCost: double.parse(
                                        _branchCostController.text),
                                  );

                                  context
                                      .read<SuperAdminCubit>()
                                      .updateClient(updatedClient, context);
                                },
                                child: Text('Save'),
                              )
                            : ElevatedButton(
                                onPressed: () {
                                  context
                                      .read<SuperAdminCubit>()
                                      .toggleEditClient(client);
                                },
                                child: Text('Edit'),
                              ),
                        SizedBox(height: 20),
                        if (client.admins.isNotEmpty ||
                            client.branches.isNotEmpty)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(18.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            'Admins',
                                            style: TextStyle(
                                              fontSize: fontSize + 4,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(width: size.width * 0.1),
                                          IconButton(
                                            icon: Icon(Icons.add),
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      AddUserScreenSuper(
                                                          clientId: clientId),
                                                ),
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 8),
                                      Container(
                                        height: size.height * 0.3,
                                        child: GridView.count(
                                          crossAxisCount: 3,
                                          shrinkWrap: true,
                                          mainAxisSpacing: 8.0,
                                          crossAxisSpacing: 8.0,
                                          childAspectRatio: 2,
                                          children: [
                                            ...client.admins.map((adminn) =>
                                                GestureDetector(
                                                  onTap: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            EditAdminScreen(
                                                          clientId: clientId,
                                                          admin: adminn,
                                                          employeeId:
                                                              adminn.employeeId,
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                  child: Container(
                                                    padding:
                                                        EdgeInsets.all(padding),
                                                    decoration: BoxDecoration(
                                                      color:
                                                          AppColors.colorGreen,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10.0),
                                                    ),
                                                    child: Center(
                                                      child: Text(
                                                        adminn.name,
                                                        style: TextStyle(
                                                          fontSize: fontSize,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                )),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(width: 8),
                              Container(
                                width: 1,
                                height: size.height * 0.3,
                                color: Colors.grey,
                              ),
                              SizedBox(width: 8),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(18.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            'Branches',
                                            style: TextStyle(
                                              fontSize: fontSize + 4,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(width: size.width * 0.1),
                                          IconButton(
                                            icon: Icon(Icons.add),
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      AddBranchScreenSuper(
                                                          clientId: clientId),
                                                ),
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 8),
                                      Container(
                                        height: size.height * 0.3,
                                        child: GridView.count(
                                          crossAxisCount: 3,
                                          shrinkWrap: true,
                                          mainAxisSpacing: 8.0,
                                          crossAxisSpacing: 8.0,
                                          childAspectRatio: 2,
                                          children: [
                                            ...client.branches.map(
                                              (branch) => GestureDetector(
                                                  onTap: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            EditBranchScreen(
                                                          clientId: clientId,
                                                          branch: branch,
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                  child: Container(
                                                    padding:
                                                        EdgeInsets.all(padding),
                                                    decoration: BoxDecoration(
                                                      color:
                                                          AppColors.colorGreen,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10.0),
                                                    ),
                                                    child: Center(
                                                      child: Text(
                                                        branch.name,
                                                        style: TextStyle(
                                                          fontSize: fontSize,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    ),
                                                  )),
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
