import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:huma_plus/core/enums/user_role.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/storage/shared_pref_helper.dart';
import 'package:huma_plus/core/entities/user_entity.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../../../../shared/widgets/custom_input.dart';
import '../../../clients/presentation/cubit/client_cubit.dart';
import '../../../clients/presentation/cubit/client_state.dart';
import '../../../clients/domain/entities/client_entity.dart';
import '../cubit/branch_cubit.dart';
import '../../domain/entities/branch_entity.dart';

class BranchesCreateScreen extends StatefulWidget {
  const BranchesCreateScreen({super.key});

  @override
  State<BranchesCreateScreen> createState() => _BranchesCreateScreenState();
}

class _BranchesCreateScreenState extends State<BranchesCreateScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _managerController = TextEditingController();
  final _descriptionController = TextEditingController();

  ClientEntity? _selectedClient;
  UserEntity? _currentUser;
  bool _isSuperAdmin = false;

  @override
  void initState() {
    super.initState();
    _loadCurrentUser();
  }

  void _loadCurrentUser() {
    final user = SharedPrefHelper.getUser();
    if (user != null) {
      setState(() {
        _currentUser = user;
        _isSuperAdmin = user.role == UserRole.superAdmin;
        if (!_isSuperAdmin) {
          // For non-super admin, use their tenant ID
          _selectedClient = ClientEntity(
            id: user.tenantId,
            name: 'Current Client',
            plan: 'Free',
            subscriptionStart: DateTime.now(),
            subscriptionEnd: DateTime.now().add(const Duration(days: 30)),
            billingAmount: 0.0,
            billingInterval: 'monthly',
            isActive: true,
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
            allowedBranches: 1,
            allowedUsers: 1,
            currentBranches: 1,
            currentUsers: 1,
          );
        }
      });

      // Load clients if super admin
      if (_isSuperAdmin) {
        context.read<ClientCubit>().getClients();
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _managerController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => getIt<BranchCubit>()),
        BlocProvider<ClientCubit>(
          create: (_) => getIt<ClientCubit>(),
        )
      ],
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Add New Branch'),
          backgroundColor: Theme.of(context).primaryColor,
          foregroundColor: Colors.white,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.go('/branches'),
          ),
        ),
        body: BlocListener<BranchCubit, BranchState>(
          listener: (context, state) {
            if (state is BranchLoaded) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Branch created successfully!'),
                  backgroundColor: Colors.green,
                ),
              );
              context.go('/branches');
            } else if (state is BranchError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                padding: EdgeInsets.all(constraints.maxWidth > 600 ? 32 : 16),
                child: Center(
                  child: Container(
                    constraints: const BoxConstraints(maxWidth: 800),
                    child: Card(
                      elevation: 4,
                      child: Padding(
                        padding: EdgeInsets.all(
                            constraints.maxWidth > 600 ? 32 : 16),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Header
                              Row(
                                children: [
                                  Icon(
                                    Icons.location_city,
                                    size: 32,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  const SizedBox(width: 16),
                                  const Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Create New Branch',
                                          style: TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          'Add a new branch to the system',
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 32),

                              // Client Selection (Super Admin only)
                              if (_isSuperAdmin) ...[
                                _buildClientSelection(),
                                const SizedBox(height: 24),
                              ],

                              // Form Fields
                              _buildResponsiveFormFields(constraints),

                              const SizedBox(height: 32),

                              // Action Buttons
                              _buildActionButtons(context, constraints),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildClientSelection() {
    return BlocBuilder<ClientCubit, ClientState>(
      builder: (context, state) {
        if (state is ClientLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is ClientsLoaded) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Select Client',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: DropdownButtonFormField<ClientEntity>(
                  value: _selectedClient,
                  decoration: const InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    border: InputBorder.none,
                    hintText: 'Choose a client',
                  ),
                  items: state.clients.map((client) {
                    return DropdownMenuItem<ClientEntity>(
                      value: client,
                      child: Text(client.name),
                    );
                  }).toList(),
                  onChanged: (ClientEntity? newValue) {
                    setState(() {
                      _selectedClient = newValue;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Please select a client';
                    }
                    return null;
                  },
                ),
              ),
            ],
          );
        }

        return Container();
      },
    );
  }

  Widget _buildResponsiveFormFields(BoxConstraints constraints) {
    final isWideScreen = constraints.maxWidth > 600;

    if (isWideScreen) {
      return Column(
        children: [
          Row(
            children: [
              Expanded(
                child: CustomInput(
                  controller: _nameController,
                  label: 'Branch Name',
                  hintText: 'Enter branch name',
                  prefixIcon: Icons.business,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter branch name';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: CustomInput(
                  controller: _phoneController,
                  label: 'Phone',
                  hintText: 'Enter phone number',
                  prefixIcon: Icons.phone,
                  keyboardType: TextInputType.phone,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: CustomInput(
                  controller: _emailController,
                  label: 'Email',
                  hintText: 'Enter email address',
                  prefixIcon: Icons.email,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value != null && value.isNotEmpty) {
                      if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                          .hasMatch(value)) {
                        return 'Please enter a valid email';
                      }
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: CustomInput(
                  controller: _managerController,
                  label: 'Manager Name',
                  hintText: 'Enter manager name',
                  prefixIcon: Icons.person,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          CustomInput(
            controller: _addressController,
            label: 'Address',
            hintText: 'Enter branch address',
            prefixIcon: Icons.location_on,
            maxLines: 2,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter branch address';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          CustomInput(
            controller: _descriptionController,
            label: 'Description',
            hintText: 'Enter branch description (optional)',
            prefixIcon: Icons.description,
            maxLines: 3,
          ),
        ],
      );
    } else {
      return Column(
        children: [
          CustomInput(
            controller: _nameController,
            label: 'Branch Name',
            hintText: 'Enter branch name',
            prefixIcon: Icons.business,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter branch name';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          CustomInput(
            controller: _phoneController,
            label: 'Phone',
            hintText: 'Enter phone number',
            prefixIcon: Icons.phone,
            keyboardType: TextInputType.phone,
          ),
          const SizedBox(height: 16),
          CustomInput(
            controller: _emailController,
            label: 'Email',
            hintText: 'Enter email address',
            prefixIcon: Icons.email,
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value != null && value.isNotEmpty) {
                if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                    .hasMatch(value)) {
                  return 'Please enter a valid email';
                }
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          CustomInput(
            controller: _managerController,
            label: 'Manager Name',
            hintText: 'Enter manager name',
            prefixIcon: Icons.person,
          ),
          const SizedBox(height: 16),
          CustomInput(
            controller: _addressController,
            label: 'Address',
            hintText: 'Enter branch address',
            prefixIcon: Icons.location_on,
            maxLines: 2,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter branch address';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          CustomInput(
            controller: _descriptionController,
            label: 'Description',
            hintText: 'Enter branch description (optional)',
            prefixIcon: Icons.description,
            maxLines: 3,
          ),
        ],
      );
    }
  }

  Widget _buildActionButtons(BuildContext context, BoxConstraints constraints) {
    final isWideScreen = constraints.maxWidth > 600;

    return BlocBuilder<BranchCubit, BranchState>(
      builder: (context, state) {
        final isLoading = state is BranchLoading;

        if (isWideScreen) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              OutlinedButton(
                onPressed: isLoading ? null : () => context.go('/branches'),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  child: Text('Cancel'),
                ),
              ),
              const SizedBox(width: 16),
              CustomButton(
                text: 'Create Branch',
                onPressed: isLoading ? null : _createBranch,
                isLoading: isLoading,
                icon: Icons.add,
              ),
            ],
          );
        } else {
          return Column(
            children: [
              SizedBox(
                width: double.infinity,
                child: CustomButton(
                  text: 'Create Branch',
                  onPressed: isLoading ? null : _createBranch,
                  isLoading: isLoading,
                  icon: Icons.add,
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: isLoading ? null : () => context.go('/branches'),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Text('Cancel'),
                  ),
                ),
              ),
            ],
          );
        }
      },
    );
  }

  void _createBranch() {
    if (_formKey.currentState!.validate()) {
      if (_isSuperAdmin && _selectedClient == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please select a client'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      final branch = BranchEntity(
        id: '',
        tenantId: _selectedClient?.id ?? _currentUser?.tenantId ?? '',
        name: _nameController.text.trim(),
        latitude: 0.0,
        longitude: 0.0,
        address: _addressController.text.trim().isEmpty
            ? null
            : _addressController.text.trim(),
        radiusMeters: 100.0,
        details: {
          'phone': _phoneController.text.trim(),
          'email': _emailController.text.trim(),
          'manager': _managerController.text.trim(),
          'description': _descriptionController.text.trim(),
        },
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      context.read<BranchCubit>().createBranch(branch);
    }
  }
}
