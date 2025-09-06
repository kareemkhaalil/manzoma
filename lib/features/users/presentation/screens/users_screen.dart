import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:manzoma/core/entities/user_entity.dart';
import 'package:manzoma/core/enums/user_role.dart';
import 'package:manzoma/core/localization/app_localizations.dart';
import '../cubit/user_cubit.dart';
export 'package:manzoma/core/entities/user_entity.dart';
import '../widgets/add_user_dialog.dart';
import '../widgets/user_card.dart';
import 'package:flutter_localization/flutter_localization.dart';

class UsersScreen extends StatefulWidget {
  const UsersScreen({super.key});

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  UserRole? selectedRole;
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    // Load users when screen initializes
    context.read<UserCubit>().getUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          FlutterLocalization.instance.getString(context, 'manageUsers'),
          style: TextStyle(
            fontSize: 24.sp,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF2563EB),
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () => _showAddUserDialog(context),
            icon: const Icon(Icons.add, color: Colors.white),
            tooltip: FlutterLocalization.instance.getString(context, 'addNewUser'),
          ),
          SizedBox(width: 16.w),
        ],
      ),
      body: Column(
        children: [
          // Search and Filter Section
          Container(
            padding: EdgeInsets.all(16.w),
            color: Colors.white,
            child: Column(
              children: [
                // Search Bar
                TextField(
                  onChanged: (value) {
                    setState(() {
                      searchQuery = value;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: FlutterLocalization.instance.getString(context, 'searchForUser'),
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                  ),
                ),
                SizedBox(height: 12.h),
                // Role Filter
                Row(
                  children: [
                    Text(
                      FlutterLocalization.instance.getString(context, 'filterByRole'),
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: DropdownButtonFormField<UserRole>(
                        value: selectedRole,
                        hint: Text(FlutterLocalization.instance.getString(context, 'allRoles')),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 12.w,
                            vertical: 8.h,
                          ),
                        ),
                        items: [
                          DropdownMenuItem(
                            value: null,
                            child: Text(FlutterLocalization.instance.getString(context, 'allRoles')),
                          ),
                          DropdownMenuItem(
                            value: UserRole.superAdmin,
                            child: Text(FlutterLocalization.instance.getString(context, 'superAdmin')),
                          ),
                          DropdownMenuItem(
                            value: UserRole.cad,
                            child: Text(FlutterLocalization.instance.getString(context, 'branchManager')),
                          ),
                          DropdownMenuItem(
                            value: UserRole.employee,
                            child: Text(FlutterLocalization.instance.getString(context, 'employee')),
                          ),
                        ],
                        onChanged: (value) {
                          setState(() {
                            selectedRole = value;
                          });
                          // Reload users with filter
                          context.read<UserCubit>().getUsers(role: value);
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Users List
          Expanded(
            child: BlocBuilder<UserCubit, UserState>(
              builder: (context, state) {
                if (state is UserLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is UserError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 64.w,
                          color: Colors.red,
                        ),
                        SizedBox(height: 16.h),
                        Text(
                          '${FlutterLocalization.instance.getString(context, 'error')}: ${state.message}',
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: Colors.red,
                          ),
                        ),
                        SizedBox(height: 16.h),
                        ElevatedButton(
                          onPressed: () {
                            context.read<UserCubit>().getUsers();
                          },
                          child: Text(FlutterLocalization.instance.getString(context, 'retry')),
                        ),
                      ],
                    ),
                  );
                } else if (state is UserLoaded) {
                  final filteredUsers = state.users.where((user) {
                    final matchesSearch = searchQuery.isEmpty ||
                        user.name
                                ?.toLowerCase()
                                .contains(searchQuery.toLowerCase()) ==
                            true ||
                        user.email
                                ?.toLowerCase()
                                .contains(searchQuery.toLowerCase()) ==
                            true;
                    return matchesSearch;
                  }).toList();

                  if (filteredUsers.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.people_outline,
                            size: 64.w,
                            color: Colors.grey,
                          ),
                          SizedBox(height: 16.h),
                          Text(
                            FlutterLocalization.instance.getString(context, 'noUsersFound'),
                            style: TextStyle(
                              fontSize: 18.sp,
                              color: Colors.grey[600],
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            FlutterLocalization.instance.getString(context, 'pressToAddUser'),
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return RefreshIndicator(
                    onRefresh: () async {
                      context.read<UserCubit>().getUsers(role: selectedRole);
                    },
                    child: ListView.builder(
                      padding: EdgeInsets.all(16.w),
                      itemCount: filteredUsers.length,
                      itemBuilder: (context, index) {
                        return UserCard(
                          user: filteredUsers[index],
                          onTap: () =>
                              _showUserDetails(context, filteredUsers[index]),
                        );
                      },
                    ),
                  );
                }
                return const SizedBox();
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showAddUserDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const AddUserDialog(),
    );
  }

  void _showUserDetails(BuildContext context, UserEntity user) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(user.displayName),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow(FlutterLocalization.instance.getString(context, 'email'), user.email ?? FlutterLocalization.instance.getString(context, 'notSpecified')),
            _buildDetailRow(FlutterLocalization.instance.getString(context, 'phone'), user.phone ?? FlutterLocalization.instance.getString(context, 'notSpecified')),
            _buildDetailRow(FlutterLocalization.instance.getString(context, 'role'), _getRoleDisplayName(user.role.toString())),
            _buildDetailRow(FlutterLocalization.instance.getString(context, 'basicSalary'), '${user.baseSalary} ${FlutterLocalization.instance.getString(context, 'currency')}'),
            _buildDetailRow(FlutterLocalization.instance.getString(context, 'status'), user.isActive ? FlutterLocalization.instance.getString(context, 'active') : FlutterLocalization.instance.getString(context, 'inactive')),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(FlutterLocalization.instance.getString(context, 'close')),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100.w,
            child: Text(
              '$label:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14.sp,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(fontSize: 14.sp),
            ),
          ),
        ],
      ),
    );
  }

  String _getRoleDisplayName(String role) {
    switch (role) {
      case 'super_admin':
        return FlutterLocalization.instance.getString(context, 'superAdmin');
      case 'cad':
        return FlutterLocalization.instance.getString(context, 'branchManager');
      case 'employee':
        return FlutterLocalization.instance.getString(context, 'employee');
      default:
        return role;
    }
  }
}
