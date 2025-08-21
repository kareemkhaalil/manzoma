import 'package:flutter/material.dart';
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

  // Controllers for all fields from the dialog
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

  // State variables for dropdowns and dates
  String _selectedPlan = 'free';
  String _selectedBillingInterval = 'monthly';
  DateTime? _subscriptionStart;
  DateTime? _subscriptionEnd;

  final List<String> _plans = ['free', 'basic', 'premium', 'enterprise'];
  final List<String> _billingIntervals = ['monthly', 'quarterly', 'yearly'];

  @override
  void initState() {
    super.initState();
    // Initialize with default values
    _subscriptionStart = DateTime.now();
    _subscriptionEnd = DateTime.now().add(const Duration(days: 365));
    _subscriptionStartController.text =
        DateFormat('yyyy-MM-dd').format(_subscriptionStart!);
    _subscriptionEndController.text =
        DateFormat('yyyy-MM-dd').format(_subscriptionEnd!);
    _billingAmountController.text = '0.00';
    _allowedBranchesController.text = '1';
    _allowedUsersController.text = '1';
  }

  @override
  void dispose() {
    // Dispose all controllers
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
    return BlocProvider<ClientCubit>(
      create: (_) => getIt<ClientCubit>(),
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
        body: BlocListener<ClientCubit, ClientState>(
          listener: (context, state) {
            if (state is ClientCreated) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Client created successfully!'),
                  backgroundColor: Colors.green,
                ),
              );
              context.go('/clients');
            } else if (state is ClientError) {
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
                padding: EdgeInsets.all(constraints.maxWidth > 800 ? 32 : 16),
                child: Center(
                  child: Container(
                    constraints: const BoxConstraints(maxWidth: 800),
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(
                            constraints.maxWidth > 800 ? 32 : 16),
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

                              // Form Fields
                              _buildResponsiveFormFields(constraints),

                              const SizedBox(height: 32),

                              // Action Buttons
                              _buildActionButtons(context),
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

  Widget _buildResponsiveFormFields(BoxConstraints constraints) {
    final isWideScreen = constraints.maxWidth > 600;

    return Column(
      children: [
        // Basic Info Section
        _buildSectionHeader('Basic Information'),
        if (isWideScreen)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                  child: CustomInput(
                      controller: _nameController,
                      label: 'Company Name',
                      hintText: 'Enter company name',
                      validator: (v) => v!.isEmpty ? 'Required' : null)),
              const SizedBox(width: 16),
              Expanded(
                  child: CustomInput(
                      controller: _emailController,
                      label: 'Email',
                      hintText: 'Enter email address')),
            ],
          )
        else ...[
          CustomInput(
              controller: _nameController,
              label: 'Company Name',
              hintText: 'Enter company name',
              validator: (v) => v!.isEmpty ? 'Required' : null),
          const SizedBox(height: 16),
          CustomInput(
              controller: _emailController,
              label: 'Email',
              hintText: 'Enter email address'),
        ],
        const SizedBox(height: 16),
        if (isWideScreen)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                  child: CustomInput(
                      controller: _phoneController,
                      label: 'Phone',
                      hintText: 'Enter phone number')),
              const SizedBox(width: 16),
              Expanded(
                  child: CustomInput(
                      controller: _websiteController,
                      label: 'Website',
                      hintText: 'Enter website URL')),
            ],
          )
        else ...[
          CustomInput(
              controller: _phoneController,
              label: 'Phone',
              hintText: 'Enter phone number'),
          const SizedBox(height: 16),
          CustomInput(
              controller: _websiteController,
              label: 'Website',
              hintText: 'Enter website URL'),
        ],
        const SizedBox(height: 16),
        CustomInput(
            controller: _addressController,
            label: 'Address',
            hintText: 'Enter company address'),
        const SizedBox(height: 16),
        CustomInput(
            controller: _descriptionController,
            label: 'Description',
            hintText: 'Optional description',
            maxLines: 3),

        const SizedBox(height: 24),
        const Divider(),
        const SizedBox(height: 16),

        // Plan & Billing Section
        _buildSectionHeader('Plan & Billing'),
        if (isWideScreen)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _buildPlanDropdown()),
              const SizedBox(width: 16),
              Expanded(
                  child: CustomInput(
                      controller: _billingAmountController,
                      label: 'Billing Amount',
                      keyboardType: TextInputType.number)),
            ],
          )
        else ...[
          _buildPlanDropdown(),
          const SizedBox(height: 16),
          CustomInput(
              controller: _billingAmountController,
              label: 'Billing Amount',
              keyboardType: TextInputType.number),
        ],
        const SizedBox(height: 16),
        if (isWideScreen)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _buildBillingIntervalDropdown()),
              const SizedBox(width: 16),
              Expanded(
                  child: CustomInput(
                      controller: _allowedBranchesController,
                      label: 'Allowed Branches',
                      keyboardType: TextInputType.number)),
            ],
          )
        else ...[
          _buildBillingIntervalDropdown(),
          const SizedBox(height: 16),
          CustomInput(
              controller: _allowedBranchesController,
              label: 'Allowed Branches',
              keyboardType: TextInputType.number),
        ],
        const SizedBox(height: 16),
        CustomInput(
            controller: _allowedUsersController,
            label: 'Allowed Users',
            keyboardType: TextInputType.number),
        const SizedBox(height: 16),
        if (isWideScreen)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                  child: CustomInput(
                      controller: _subscriptionStartController,
                      label: 'Subscription Start',
                      readOnly: true,
                      onTap: () => _selectDate(context, true))),
              const SizedBox(width: 16),
              Expanded(
                  child: CustomInput(
                      controller: _subscriptionEndController,
                      label: 'Subscription End',
                      readOnly: true,
                      onTap: () => _selectDate(context, false))),
            ],
          )
        else ...[
          CustomInput(
              controller: _subscriptionStartController,
              label: 'Subscription Start',
              readOnly: true,
              onTap: () => _selectDate(context, true)),
          const SizedBox(height: 16),
          CustomInput(
              controller: _subscriptionEndController,
              label: 'Subscription End',
              readOnly: true,
              onTap: () => _selectDate(context, false)),
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

  Widget _buildActionButtons(BuildContext context) {
    return BlocBuilder<ClientCubit, ClientState>(
      builder: (context, state) {
        final isLoading = state is ClientLoading;
        return Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              onPressed: isLoading ? null : () => context.go('/clients'),
              child: const Text('Cancel'),
            ),
            const SizedBox(width: 16),
            CustomButton(
              text: 'Create Client',
              onPressed: isLoading ? null : _createClient,
              isLoading: isLoading,
              icon: Icons.add,
            ),
          ],
        );
      },
    );
  }

  Future<void> _selectDate(BuildContext context, bool isStart) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isStart
          ? (_subscriptionStart ?? DateTime.now())
          : (_subscriptionEnd ?? DateTime.now()),
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
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

  void _createClient() {
    if (_formKey.currentState!.validate()) {
      final billingAmount =
          double.tryParse(_billingAmountController.text) ?? 0.0;
      final allowedBranches =
          int.tryParse(_allowedBranchesController.text) ?? 1;
      final allowedUsers = int.tryParse(_allowedUsersController.text) ?? 1;

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
  }
}
