import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:manzoma/core/enums/user_role.dart';
import 'package:manzoma/core/di/injection_container.dart';
import 'package:manzoma/core/storage/shared_pref_helper.dart' as sp;

import '../../../../shared/widgets/custom_button.dart';
import '../../../../shared/widgets/custom_input.dart';

import '../../../clients/domain/entities/client_entity.dart';
import '../../../clients/presentation/cubit/client_cubit.dart';
import '../../../clients/presentation/cubit/client_state.dart';

import '../../domain/entities/user_entity.dart' as app_user;
import '../cubit/user_cubit.dart';

class UsersCreateScreen extends StatefulWidget {
  const UsersCreateScreen({super.key});

  @override
  State<UsersCreateScreen> createState() => _UsersCreateScreenState();
}

class _UsersCreateScreenState extends State<UsersCreateScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _passwordCtrl =
      TextEditingController(); // --- جديد: حقل كلمة المرور ---

  // --- جديد: متغيرات الحالة ---
  UserRole _selectedRole = UserRole.employee;
  ClientEntity? _selectedClient;
  app_user.UserEntity? _currentUser;
  bool _isSuperAdmin = false;
  bool _isLimitReached = false;

  late final UserCubit _userCubit;
  late final ClientCubit _clientCubit;

  // قائمة الأدوار المتاحة
  final List<UserRole> _roles = [
    UserRole.superAdmin,
    UserRole.cad,
    UserRole.employee
  ];

  @override
  void initState() {
    super.initState();
    // --- جديد: حقن الـ Cubits ---
    _userCubit = getIt<UserCubit>();
    _clientCubit = getIt<ClientCubit>();
    _loadCurrentUser();
  }

  // --- جديد: دالة لتحميل بيانات المستخدم الحالي وتحديد صلاحياته ---
  void _loadCurrentUser() {
    final user = sp.SharedPrefHelper.getUser();
    if (user != null) {
      _currentUser = user;
      _isSuperAdmin = user.role == UserRole.superAdmin;

      if (_isSuperAdmin) {
        // إذا كان سوبر أدمن، أحضر قائمة كل العملاء
        _clientCubit.getClients();
      } else {
        // إذا كان مستخدم عادي، أنشئ كيان عميل بناءً على بياناته
        final clientForUser = ClientEntity(
          id: user.tenantId,
          name: "My Company", // يمكنك استبدال هذا باسم الشركة الحقيقي
          // باقي البيانات يمكن أن تكون افتراضية أو تُجلب من مصدر آخر
          allowedUsers: 5, // مثال: عدد المستخدمين المسموح به
          currentUsers: 2, // مثال: عدد المستخدمين الحالي
          // ---
          plan: "Free",
          subscriptionStart: DateTime.now(),
          subscriptionEnd: DateTime.now().add(const Duration(days: 30)),
          billingAmount: 0,
          billingInterval: "monthly",
          isActive: true,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          allowedBranches: 1,
          currentBranches: 1,
        );
        setState(() {
          _selectedClient = clientForUser;
          _updateClientLimits(_selectedClient); // تحقق من الحدود فوراً
        });
      }
    }
  }

  // --- جديد: دالة مركزية للتحقق من حدود العميل ---
  void _updateClientLimits(ClientEntity? client) {
    if (client == null) {
      setState(() => _isLimitReached = false);
      return;
    }
    final allowed = client.allowedUsers;
    final current = client.currentUsers;
    final remaining = (current != null) ? (allowed - current) : 1;
    setState(() => _isLimitReached = remaining <= 0);
  }

  @override
  void dispose() {
    _userCubit.close();
    _clientCubit.close();
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _userCubit),
        BlocProvider.value(value: _clientCubit),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Add New User'),
          backgroundColor: Theme.of(context).primaryColor,
          foregroundColor: Colors.white,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.go('/users'),
          ),
        ),
        // --- جديد: استخدام BlocConsumer للتعامل مع الحالات المختلفة ---
        body: BlocConsumer<UserCubit, UserState>(
          listener: (context, state) {
            if (state is UserCreated) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                      '✅ User "${state.users.first.name}" created successfully!'),
                  backgroundColor: Colors.green,
                ),
              );
              context.go('/users'); // العودة للشاشة السابقة
            } else if (state is UserError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('❌ ${state.message}'),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          builder: (context, state) {
            final isLoading = state is UserLoading;
            return Stack(
              children: [
                _buildForm(context, isLoading),
                if (isLoading)
                  Container(
                    color: Colors.black.withOpacity(0.3),
                    child: const Center(child: CircularProgressIndicator()),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildForm(BuildContext context, bool isLoading) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          padding: EdgeInsets.all(constraints.maxWidth > 600 ? 32 : 16),
          child: Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 900),
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: EdgeInsets.all(constraints.maxWidth > 600 ? 32 : 16),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header
                        Row(
                          children: [
                            Icon(Icons.person_add,
                                size: 32,
                                color: Theme.of(context).primaryColor),
                            const SizedBox(width: 16),
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Create New User',
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    'Add a new user to the system',
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
                        const SizedBox(height: 24),

                        // --- جديد: قسم اختيار العميل ---
                        buildClientSelection(),
                        const SizedBox(height: 16),

                        // --- جديد: قسم عرض حدود المستخدمين ---
                        _buildClientLimitsStrip(),

                        // --- جديد: رسالة التحذير عند تجاوز الحد ---
                        _buildLimitWarning(),
                        const SizedBox(height: 24),

                        // --- معدّل: تمرير حالة التعطيل للحقول ---
                        _buildUserFields(isDisabled: _isLimitReached),
                        const SizedBox(height: 32),

                        // --- معدّل: تمرير حالة التعطيل للأزرار ---
                        buildActionButtons(context, isLoading, _isLimitReached),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // --- جديد: ودجت لعرض حدود العميل (مسموح/متبقي) ---
  Widget _buildClientLimitsStrip() {
    final allowed = _selectedClient?.allowedUsers;
    final current = _selectedClient?.currentUsers;
    final remaining =
        (allowed != null && current != null) ? (allowed - current) : null;

    return Row(
      children: [
        _miniInfoCard(
          title: 'Allowed users',
          value: allowed?.toString() ?? '--',
          icon: Icons.verified_user,
        ),
        const SizedBox(width: 12),
        _miniInfoCard(
          title: 'Remaining',
          value: remaining?.toString() ?? '--',
          icon: Icons.person_add_alt_1,
          valueColor:
              (remaining != null && remaining <= 0) ? Colors.red : Colors.green,
        ),
      ],
    );
  }

  // --- جديد: ودجت رسالة التحذير ---
  Widget _buildLimitWarning() {
    if (!_isLimitReached) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.red.shade50,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.red.shade200),
        ),
        child: const Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.red),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                'User limit reached. All fields are disabled.',
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- جديد: ودجت البطاقة الصغيرة لعرض المعلومات ---
  Widget _miniInfoCard({
    required String title,
    required String value,
    required IconData icon,
    Color? valueColor,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          children: [
            Icon(icon, size: 22, color: Theme.of(context).primaryColor),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style:
                          const TextStyle(fontSize: 12, color: Colors.black54)),
                  const SizedBox(height: 2),
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: valueColor ?? Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- جديد: ودجت اختيار العميل ---
  Widget buildClientSelection() {
    if (_isSuperAdmin) {
      return BlocBuilder<ClientCubit, ClientState>(
        builder: (context, state) {
          if (state is ClientLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is ClientsLoaded) {
            // اختيار أول عميل تلقائيا إذا لم يتم اختيار أي عميل بعد
            if (_selectedClient == null && state.clients.isNotEmpty) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (mounted) {
                  setState(() => _selectedClient = state.clients.first);
                  _updateClientLimits(_selectedClient);
                }
              });
            }
            return buildClientDropdown(state.clients, _selectedClient);
          }
          return Container(); // في حالة الخطأ أو عدم وجود عملاء
        },
      );
    } else {
      // للمستخدم العادي، يتم عرض العميل الخاص به فقط
      if (_selectedClient != null) {
        return buildClientDropdown([_selectedClient!], _selectedClient,
            isEnabled: false); // غير قابل للتغيير
      }
      return Container();
    }
  }

  // --- جديد: ودجت القائمة المنسدلة للعملاء ---
  Widget buildClientDropdown(List<ClientEntity> clients, ClientEntity? initial,
      {bool isEnabled = true}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Select Client',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<ClientEntity>(
          value: initial,
          decoration: InputDecoration(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            border: const OutlineInputBorder(),
            hintText: 'Choose a client',
            filled: !isEnabled,
            fillColor: Colors.grey.shade200,
          ),
          items: clients
              .map((client) => DropdownMenuItem<ClientEntity>(
                    value: client,
                    child: Text(client.name),
                  ))
              .toList(),
          onChanged: isEnabled
              ? (ClientEntity? newValue) {
                  setState(() => _selectedClient = newValue);
                  _updateClientLimits(newValue); // تحديث الحدود عند التغيير
                }
              : null,
          validator: (value) => value == null ? 'Please select a client' : null,
        ),
      ],
    );
  }

  // --- معدّل: ودجت حقول المستخدم مع إضافة خاصية التعطيل ---
  Widget _buildUserFields({required bool isDisabled}) {
    return AbsorbPointer(
      absorbing: isDisabled,
      child: Opacity(
        opacity: isDisabled ? 0.5 : 1.0,
        child: Column(
          children: [
            CustomInput(
              controller: _nameCtrl,
              label: 'Full Name',
              hintText: 'Enter user full name',
              prefixIcon: Icons.person,
              validator: (v) =>
                  v == null || v.trim().isEmpty ? 'Name is required' : null,
            ),
            const SizedBox(height: 16),
            CustomInput(
              controller: _emailCtrl,
              label: 'Email Address',
              hintText: 'Enter user email',
              prefixIcon: Icons.email,
              keyboardType: TextInputType.emailAddress,
              validator: (v) {
                if (v == null || v.trim().isEmpty) return 'Email is required';
                final ok =
                    RegExp(r'^[\w\.-]+@([\w-]+\.)+[\w-]{2,}$').hasMatch(v);
                if (!ok) return 'Please enter a valid email';
                return null;
              },
            ),
            const SizedBox(height: 16),
            CustomInput(
              controller: _passwordCtrl,
              label: 'Password',
              hintText: 'Enter a strong password',
              prefixIcon: Icons.lock,
              isPassword: true,
              validator: (v) {
                if (v == null || v.isEmpty) return 'Password is required';
                if (v.length < 6)
                  return 'Password must be at least 6 characters';
                return null;
              },
            ),
            const SizedBox(height: 16),
            CustomInput(
              controller: _phoneCtrl,
              label: 'Phone Number',
              hintText: 'Enter user phone number',
              prefixIcon: Icons.phone,
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<UserRole>(
              value: _selectedRole,
              decoration: const InputDecoration(
                labelText: 'Role',
                prefixIcon: Icon(Icons.security),
                border: OutlineInputBorder(),
              ),
              items: _roles
                  .map((role) => DropdownMenuItem<UserRole>(
                        value: role,
                        child: Text(role.name.toUpperCase()),
                      ))
                  .toList(),
              onChanged: (UserRole? newValue) {
                if (newValue != null) {
                  setState(() {
                    _selectedRole = newValue;
                  });
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  // --- جديد: ودجت أزرار الإجراءات (إنشاء وإلغاء) ---
  Widget buildActionButtons(
      BuildContext context, bool isLoading, bool isDisabled) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        OutlinedButton(
          onPressed: isLoading ? null : () => context.go('/users'),
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            child: Text('Cancel'),
          ),
        ),
        const SizedBox(width: 16),
        CustomButton(
          text: 'Create User',
          onPressed: isLoading || isDisabled ? null : _onCreatePressed,
          isLoading: isLoading,
          icon: Icons.add,
        ),
      ],
    );
  }

  // --- جديد: منطق الضغط على زر الإنشاء ---
  void _onCreatePressed() {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) return;

    // التأكد من اختيار عميل (خاص بالسوبر أدمن)
    if (_isSuperAdmin && _selectedClient == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a client before creating a user.'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    final user = app_user.UserEntity(
      id: '', // سيتم إنشاؤه في الباك-إند
      tenantId: _selectedClient!.id,
      name: _nameCtrl.text.trim(),
      email: _emailCtrl.text.trim(),
      phone: _phoneCtrl.text.trim(),
      role: _selectedRole,
      password: _passwordCtrl.text, // تمرير كلمة المرور
      isActive: true, // افتراضي
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    _userCubit.createUser(user);
  }
}
