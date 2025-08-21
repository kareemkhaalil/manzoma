import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:huma_plus/core/enums/user_role.dart';
import 'package:huma_plus/features/clients/presentation/cubit/client_state.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../../../../shared/widgets/custom_input.dart';
import '../../../clients/domain/entities/client_entity.dart';
import '../../../clients/presentation/cubit/client_cubit.dart';
import '../../domain/entities/user_entity.dart';
import '../cubit/user_cubit.dart';

class UsersCreateScreen extends StatefulWidget {
  final UserEntity? user;
  final bool isSuperAdmin;
  final String? currentTenantId;

  const UsersCreateScreen({
    super.key,
    this.user,
    required this.isSuperAdmin,
    this.currentTenantId,
  });

  @override
  State<UsersCreateScreen> createState() => _UsersCreateScreenState();
}

class _UsersCreateScreenState extends State<UsersCreateScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();

  String _selectedRole = 'employee';
  String? _selectedClientId;

  final List<String> _roles = ['super_admin', 'admin', 'manager', 'employee'];

  @override
  void initState() {
    super.initState();
    if (widget.user != null) {
      _initializeWithUser();
    }
  }

  void _initializeWithUser() {
    final user = widget.user!;
    _nameCtrl.text = user.name!;
    _emailCtrl.text = user.email!;
    _phoneCtrl.text = user.phone!;
    _selectedRole = user.role.name;
    _selectedClientId = user.tenantId;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.user != null;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        width: 500,
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Icon(
                    isEditing ? Icons.edit : Icons.person_add,
                    color: Theme.of(context).primaryColor,
                    size: 28,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    isEditing ? 'Edit User' : 'Add New User',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Name
              CustomInput(
                controller: _nameCtrl,
                label: 'Full Name',
                hintText: 'Enter full name',
                validator: (val) =>
                    val == null || val.isEmpty ? "Please enter name" : null,
              ),

              const SizedBox(height: 16),

              // Email
              CustomInput(
                controller: _emailCtrl,
                label: 'Email',
                hintText: 'Enter email',
                validator: (val) =>
                    val == null || val.isEmpty ? "Please enter email" : null,
              ),

              const SizedBox(height: 16),

              // Phone
              CustomInput(
                controller: _phoneCtrl,
                label: 'Phone Number',
                hintText: 'Enter phone number',
              ),

              const SizedBox(height: 16),

              // Role selection
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Role',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    value: _selectedRole,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                    items: _roles.map((role) {
                      return DropdownMenuItem(
                        value: role,
                        child: Text(role.toUpperCase()),
                      );
                    }).toList(),
                    onChanged: (val) {
                      setState(() => _selectedRole = val!);
                    },
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Client selection (for SuperAdmin only)
              if (widget.isSuperAdmin)
                BlocBuilder<ClientCubit, ClientState>(
                  builder: (context, state) {
                    if (state is ClientLoaded) {
                      final List<ClientEntity> clients =
                          state.client as List<ClientEntity>;
                      return DropdownButtonFormField<String>(
                        value: _selectedClientId,
                        decoration: InputDecoration(
                          labelText: "Select Client",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                        ),
                        items: clients
                            .map<DropdownMenuItem<String>>(
                                (ClientEntity c) => DropdownMenuItem<String>(
                                      value: c.id,
                                      child: Text(c.name),
                                    ))
                            .toList(growable: false),
                        onChanged: (val) {
                          setState(() => _selectedClientId = val);
                        },
                      );
                    }
                    return const Center(child: CircularProgressIndicator());
                  },
                ),

              const SizedBox(height: 32),

              // Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 16),
                  CustomButton(
                    text: isEditing ? "Update" : "Create",
                    onPressed: _submitForm,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final tenantId =
          widget.isSuperAdmin ? _selectedClientId : widget.currentTenantId;

      if (tenantId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please select client")),
        );
        return;
      }

      final user = UserEntity(
        id: widget.user?.id ?? "",
        tenantId: tenantId,
        branchId: null,
        email: _emailCtrl.text,
        role: UserRoleX.fromValue(_selectedRole),
        name: _nameCtrl.text,
        phone: _phoneCtrl.text,
        avatar: null,
        baseSalary: 0,
        allowances: const [],
        deductions: const [],
        workSchedule: const {},
        isActive: true,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      if (widget.user != null) {
        context.read<UserCubit>().createUser(user);
      } else {
        context.read<UserCubit>().createUser(user);
      }

      Navigator.of(context).pop();
    }
  }
}
