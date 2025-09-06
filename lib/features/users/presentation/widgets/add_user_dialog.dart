import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:manzoma/core/enums/user_role.dart';
import 'package:manzoma/core/localization/app_localizations.dart';
import '../../domain/entities/user_entity.dart';
import '../cubit/user_cubit.dart';
import 'package:flutter_localization/flutter_localization.dart';

class AddUserDialog extends StatefulWidget {
  const AddUserDialog({super.key});

  @override
  State<AddUserDialog> createState() => _AddUserDialogState();
}

class _AddUserDialogState extends State<AddUserDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _salaryController = TextEditingController();

  UserRole _selectedRole = UserRole.employee;
  bool _isActive = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _salaryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Container(
        width: 500.w,
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Row(
              children: [
                Icon(
                  Icons.person_add,
                  size: 24.w,
                  color: const Color(0xFF2563EB),
                ),
                SizedBox(width: 12.w),
                Text(
                  FlutterLocalization.instance.getString(context, 'addNewUser'),
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            SizedBox(height: 24.h),
            // Form
            Form(
              key: _formKey,
              child: Column(
                children: [
                  // Name Field
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: '${FlutterLocalization.instance.getString(context, 'fullName')} *',
                      prefixIcon: const Icon(Icons.person),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return FlutterLocalization.instance.getString(context, 'pleaseEnterName');
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16.h),
                  // Email Field
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: '${FlutterLocalization.instance.getString(context, 'email')} *',
                      prefixIcon: const Icon(Icons.email),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return FlutterLocalization.instance.getString(context, 'pleaseEnterEmail');
                      }
                      if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                          .hasMatch(value)) {
                        return FlutterLocalization.instance.getString(context, 'pleaseEnterValidEmail');
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16.h),
                  // Phone Field
                  TextFormField(
                    controller: _phoneController,
                    decoration: InputDecoration(
                      labelText: FlutterLocalization.instance.getString(context, 'phone'),
                      prefixIcon: const Icon(Icons.phone),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                    keyboardType: TextInputType.phone,
                  ),
                  SizedBox(height: 16.h),
                  // Role Dropdown
                  DropdownButtonFormField<UserRole>(
                    value: _selectedRole,
                    decoration: InputDecoration(
                      labelText: '${FlutterLocalization.instance.getString(context, 'role')} *',
                      prefixIcon: const Icon(Icons.work),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                    items: [
                      DropdownMenuItem(
                        value: UserRole.employee,
                        child: Text(FlutterLocalization.instance.getString(context, 'employee')),
                      ),
                      DropdownMenuItem(
                        value: UserRole.cad,
                        child: Text(FlutterLocalization.instance.getString(context, 'branchManager')),
                      ),
                      DropdownMenuItem(
                        value: UserRole.superAdmin,
                        child: Text(FlutterLocalization.instance.getString(context, 'superAdmin')),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _selectedRole = value!;
                      });
                    },
                  ),
                  SizedBox(height: 16.h),
                  // Salary Field
                  TextFormField(
                    controller: _salaryController,
                    decoration: InputDecoration(
                      labelText:
                          '${FlutterLocalization.instance.getString(context, 'basicSalary')} (${FlutterLocalization.instance.getString(context, 'currency')})',
                      prefixIcon: const Icon(Icons.attach_money),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value != null && value.isNotEmpty) {
                        final salary = double.tryParse(value);
                        if (salary == null || salary < 0) {
                          return FlutterLocalization.instance.getString(context, 'pleaseEnterValidSalary');
                        }
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16.h),
                  // Active Switch
                  Row(
                    children: [
                      Text(
                        '${FlutterLocalization.instance.getString(context, 'userStatus')}:',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Spacer(),
                      Switch(
                        value: _isActive,
                        onChanged: (value) {
                          setState(() {
                            _isActive = value;
                          });
                        },
                      ),
                      Text(
                        _isActive
                            ? FlutterLocalization.instance.getString(context, 'active')
                            : FlutterLocalization.instance.getString(context, 'inactive'),
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: _isActive ? Colors.green : Colors.red,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 24.h),
            // Buttons
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(
                      FlutterLocalization.instance.getString(context, 'cancel'),
                      style: TextStyle(fontSize: 16.sp),
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _createUser,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2563EB),
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                    child: Text(
                      FlutterLocalization.instance.getString(context, 'add'),
                      style: TextStyle(fontSize: 16.sp),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _createUser() {
    if (_formKey.currentState!.validate()) {
      final user = UserEntity(
        id: '', // Will be generated by Supabase
        tenantId: 'default-tenant', // TODO: Get from current user context
        email: _emailController.text.trim(),
        role: _selectedRole,
        name: _nameController.text.trim(),
        phone: _phoneController.text.trim().isEmpty
            ? null
            : _phoneController.text.trim(),
        baseSalary: _salaryController.text.isEmpty
            ? 0.0
            : double.parse(_salaryController.text),
        isActive: _isActive,
      );

      context.read<UserCubit>().createUser(user);
      Navigator.of(context).pop();

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(FlutterLocalization.instance.getString(context, 'userAddedSuccessfully')),
          backgroundColor: Colors.green,
        ),
      );
    }
  }
}
