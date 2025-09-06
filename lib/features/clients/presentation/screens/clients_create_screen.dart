import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/di/injection_container.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../../../../shared/widgets/custom_input.dart';
import '../cubit/client_cubit.dart';
import '../cubit/client_state.dart';

class ClientsCreateScreen extends StatefulWidget {
  const ClientsCreateScreen({super.key});

  @override
  State<ClientsCreateScreen> createState() => _ClientsCreateScreenState();
}

class _ClientsCreateScreenState extends State<ClientsCreateScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _websiteController = TextEditingController();
  final _addressController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _billingAmountController = TextEditingController();
  final _allowedBranchesController = TextEditingController();
  final _allowedUsersController = TextEditingController();
  final _subscriptionStartController = TextEditingController();
  final _subscriptionEndController = TextEditingController();

  // Dropdowns & state
  String _selectedPlan = 'free';
  String _selectedBillingInterval = 'monthly';
  DateTime? _subscriptionStart;
  DateTime? _subscriptionEnd;

  final List<String> _plans = ['free', 'basic', 'premium', 'enterprise'];
  final List<String> _billingIntervals = ['monthly', 'quarterly', 'yearly'];

  @override
  void initState() {
    super.initState();
    _subscriptionStart = DateTime.now();
    _subscriptionEnd = DateTime.now().add(const Duration(days: 365));

    _subscriptionStartController.text =
        DateFormat('yyyy-MM-dd').format(_subscriptionStart!);
    _subscriptionEndController.text =
        DateFormat('yyyy-MM-dd').format(_subscriptionEnd!);

    _billingAmountController.text = '0.00';
    _allowedBranchesController.text = '1';
    _allowedUsersController.text = '5';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _websiteController.dispose();
    _addressController.dispose();
    _descriptionController.dispose();
    _billingAmountController.dispose();
    _allowedBranchesController.dispose();
    _allowedUsersController.dispose();
    _subscriptionStartController.dispose();
    _subscriptionEndController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: context.read<ClientCubit>(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Add New Client'),
          backgroundColor: Theme.of(context).primaryColor,
          foregroundColor: Colors.white,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.go('/clients'),
          ),
        ),
        body: BlocConsumer<ClientCubit, ClientState>(
            listener: (context, state) async {
          if (!mounted) return;

          if (state is ClientCreated) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('✅ Client created successfully!'),
                backgroundColor: Colors.green,
                duration: Duration(seconds: 2),
              ),
            );
            context.go('/clients');
          } else if (state is ClientError) {
            _showSnack('❌ ${state.message}', Colors.red);
          }
        }, builder: (context, state) {
          print("DEBUG: Current State = $state"); // مهم جدا

          final isLoading = state is ClientLoading;
          return Stack(
            children: [
              _buildFormContent(context, isLoading),
              if (isLoading)
                Container(
                  color: Colors.black.withOpacity(0.3),
                  child: const Center(child: CircularProgressIndicator()),
                ),
            ],
          );
        }),
      ),
    );
  }

  // ---------------- UI Parts ----------------

  Widget _buildFormContent(BuildContext context, bool isLoading) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          padding: EdgeInsets.all(constraints.maxWidth > 800 ? 32 : 16),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 800),
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: EdgeInsets.all(constraints.maxWidth > 800 ? 32 : 16),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header
                        Row(
                          children: [
                            Icon(
                              Icons.add_business,
                              size: 32,
                              color: Theme.of(context).primaryColor,
                            ),
                            const SizedBox(width: 16),
                            const Text(
                              'Create New Client',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 32),

                        // Fields
                        _buildResponsiveFormFields(constraints),

                        const SizedBox(height: 32),

                        // Actions
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: isLoading
                                  ? null
                                  : () => context.go('/clients'),
                              child: const Text('Cancel'),
                            ),
                            const SizedBox(width: 16),
                            CustomButton(
                              text: 'Create Client',
                              onPressed: isLoading ? null : _onSubmit,
                              isLoading: isLoading,
                              icon: Icons.add,
                            ),
                          ],
                        ),
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

  Widget _buildResponsiveFormFields(BoxConstraints constraints) {
    final isWideScreen = constraints.maxWidth > 600;

    return Column(
      children: [
        _buildSectionHeader('Basic Information'),
        if (isWideScreen)
          Row(
            children: [
              Expanded(
                child: CustomInput(
                  controller: _nameController,
                  label: 'Company Name',
                  hintText: 'Enter company name',
                  validator: (v) =>
                      v == null || v.trim().isEmpty ? 'Required' : null,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: CustomInput(
                  controller: _emailController,
                  label: 'Email',
                  hintText: 'Enter email address',
                  keyboardType: TextInputType.emailAddress,
                ),
              ),
            ],
          )
        else ...[
          CustomInput(
            controller: _nameController,
            label: 'Company Name',
            hintText: 'Enter company name',
            validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null,
          ),
          const SizedBox(height: 16),
          CustomInput(
            controller: _emailController,
            label: 'Email',
            hintText: 'Enter email address',
            keyboardType: TextInputType.emailAddress,
          ),
        ],
        const SizedBox(height: 16),
        if (isWideScreen)
          Row(
            children: [
              Expanded(
                child: CustomInput(
                  controller: _phoneController,
                  label: 'Phone',
                  hintText: 'Enter phone number',
                  keyboardType: TextInputType.phone,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: CustomInput(
                  controller: _websiteController,
                  label: 'Website',
                  hintText: 'Enter website URL',
                  keyboardType: TextInputType.url,
                ),
              ),
            ],
          )
        else ...[
          CustomInput(
            controller: _phoneController,
            label: 'Phone',
            hintText: 'Enter phone number',
            keyboardType: TextInputType.phone,
          ),
          const SizedBox(height: 16),
          CustomInput(
            controller: _websiteController,
            label: 'Website',
            hintText: 'Enter website URL',
            keyboardType: TextInputType.url,
          ),
        ],
        const SizedBox(height: 16),
        CustomInput(
          controller: _addressController,
          label: 'Address',
          hintText: 'Enter company address',
        ),
        const SizedBox(height: 16),
        CustomInput(
          controller: _descriptionController,
          label: 'Description',
          hintText: 'Optional description',
          maxLines: 3,
        ),
        const SizedBox(height: 24),
        const Divider(),
        const SizedBox(height: 16),
        _buildSectionHeader('Plan & Billing'),
        if (isWideScreen)
          Row(
            children: [
              Expanded(child: _buildPlanDropdown()),
              const SizedBox(width: 16),
              Expanded(
                child: CustomInput(
                  controller: _billingAmountController,
                  label: 'Billing Amount',
                  keyboardType: const TextInputType.numberWithOptions(
                    signed: false,
                    decimal: true,
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}'))
                  ],
                ),
              ),
            ],
          )
        else ...[
          _buildPlanDropdown(),
          const SizedBox(height: 16),
          CustomInput(
            controller: _billingAmountController,
            label: 'Billing Amount',
            keyboardType: const TextInputType.numberWithOptions(
              signed: false,
              decimal: true,
            ),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}'))
            ],
          ),
        ],
        const SizedBox(height: 16),
        if (isWideScreen)
          Row(
            children: [
              Expanded(child: _buildBillingIntervalDropdown()),
              const SizedBox(width: 16),
              Expanded(
                child: CustomInput(
                  controller: _allowedBranchesController,
                  label: 'Allowed Branches',
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                ),
              ),
            ],
          )
        else ...[
          _buildBillingIntervalDropdown(),
          const SizedBox(height: 16),
          CustomInput(
            controller: _allowedBranchesController,
            label: 'Allowed Branches',
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          ),
        ],
        const SizedBox(height: 16),
        CustomInput(
          controller: _allowedUsersController,
          label: 'Allowed Users',
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        ),
        const SizedBox(height: 16),
        if (isWideScreen)
          Row(
            children: [
              Expanded(
                child: CustomInput(
                  controller: _subscriptionStartController,
                  label: 'Subscription Start',
                  readOnly: true,
                  onTap: () => _selectDate(context, true),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: CustomInput(
                  controller: _subscriptionEndController,
                  label: 'Subscription End',
                  readOnly: true,
                  onTap: () => _selectDate(context, false),
                ),
              ),
            ],
          )
        else ...[
          CustomInput(
            controller: _subscriptionStartController,
            label: 'Subscription Start',
            readOnly: true,
            onTap: () => _selectDate(context, true),
          ),
          const SizedBox(height: 16),
          CustomInput(
            controller: _subscriptionEndController,
            label: 'Subscription End',
            readOnly: true,
            onTap: () => _selectDate(context, false),
          ),
        ],
      ],
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).primaryColor,
        ),
      ),
    );
  }

  Widget _buildPlanDropdown() {
    return DropdownButtonFormField<String>(
      value: _selectedPlan,
      decoration: InputDecoration(
        labelText: 'Plan',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
      items: _plans
          .map((p) => DropdownMenuItem(value: p, child: Text(p.toUpperCase())))
          .toList(),
      onChanged: (val) => setState(() => _selectedPlan = val!),
    );
  }

  Widget _buildBillingIntervalDropdown() {
    return DropdownButtonFormField<String>(
      value: _selectedBillingInterval,
      decoration: InputDecoration(
        labelText: 'Billing Interval',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
      items: _billingIntervals
          .map((i) => DropdownMenuItem(value: i, child: Text(i.toUpperCase())))
          .toList(),
      onChanged: (val) => setState(() => _selectedBillingInterval = val!),
    );
  }

  // ---------------- Helpers ----------------

  Future<void> _selectDate(BuildContext context, bool isStart) async {
    final DateTime now = DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate:
          isStart ? (_subscriptionStart ?? now) : (_subscriptionEnd ?? now),
      firstDate: DateTime(now.year - 5),
      lastDate: DateTime(now.year + 10),
    );

    if (picked != null) {
      setState(() {
        if (isStart) {
          _subscriptionStart = picked;
          _subscriptionStartController.text =
              DateFormat('yyyy-MM-dd').format(picked);
        } else {
          _subscriptionEnd = picked;
          _subscriptionEndController.text =
              DateFormat('yyyy-MM-dd').format(picked);
        }
      });
    }
  }

  void _onSubmit() {
    FocusScope.of(context).unfocus(); // close keyboard
    if (!_formKey.currentState!.validate()) return;

    final billingAmount =
        double.tryParse(_billingAmountController.text.trim()) ?? 0.0;
    final allowedBranches =
        int.tryParse(_allowedBranchesController.text.trim()) ?? 1;
    final allowedUsers = int.tryParse(_allowedUsersController.text.trim()) ?? 5;

    if (_subscriptionStart == null || _subscriptionEnd == null) {
      _showSnack('Please select subscription dates', Colors.red);
      return;
    }

    context.read<ClientCubit>().createClient(
          name: _nameController.text.trim(),
          plan: _selectedPlan,
          subscriptionStart: _subscriptionStart!,
          subscriptionEnd: _subscriptionEnd!,
          billingAmount: billingAmount,
          billingInterval: _selectedBillingInterval,
          allowedBranches: allowedBranches,
          allowedUsers: allowedUsers,
        );
  }

  void _showSnack(String msg, Color bg) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: bg,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
