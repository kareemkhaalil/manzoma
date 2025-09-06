import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:manzoma/core/entities/user_entity.dart';
import 'package:manzoma/core/enums/user_role.dart';
import '../cubit/user_cubit.dart';
export 'package:manzoma/core/entities/user_entity.dart';
import '../widgets/add_user_dialog.dart';
import '../widgets/user_card.dart';

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
          'إدارة المستخدمين',
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
            tooltip: 'إضافة مستخدم جديد',
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
                    hintText: 'البحث عن مستخدم...',
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
                      'تصفية حسب الدور:',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: DropdownButtonFormField<UserRole>(
                        value: selectedRole,
                        hint: const Text('جميع الأدوار'),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 12.w,
                            vertical: 8.h,
                          ),
                        ),
                        items: const [
                          DropdownMenuItem(
                            value: null,
                            child: Text('جميع الأدوار'),
                          ),
                          DropdownMenuItem(
                            value: UserRole.superAdmin,
                            child: Text('مدير عام'),
                          ),
                          DropdownMenuItem(
                            value: UserRole.cad,
                            child: Text('مدير فرع'),
                          ),
                          DropdownMenuItem(
                            value: UserRole.employee,
                            child: Text('موظف'),
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
                          'حدث خطأ: ${state.message}',
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
                          child: const Text('إعادة المحاولة'),
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
                            'لا توجد مستخدمين',
                            style: TextStyle(
                              fontSize: 18.sp,
                              color: Colors.grey[600],
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            'اضغط على + لإضافة مستخدم جديد',
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
            _buildDetailRow('البريد الإلكتروني', user.email ?? 'غير محدد'),
            _buildDetailRow('الهاتف', user.phone ?? 'غير محدد'),
            _buildDetailRow('الدور', _getRoleDisplayName(user.role.toString())),
            _buildDetailRow('الراتب الأساسي', '${user.baseSalary} ج.م'),
            _buildDetailRow('الحالة', user.isActive ? 'نشط' : 'غير نشط'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('إغلاق'),
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
        return 'مدير عام';
      case 'cad':
        return 'مدير فرع';
      case 'employee':
        return 'موظف';
      default:
        return role;
    }
  }
}
