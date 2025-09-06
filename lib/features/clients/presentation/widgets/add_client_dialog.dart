import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../../../../shared/widgets/custom_input.dart';
import '../../domain/entities/client_entity.dart';
import '../cubit/client_cubit.dart';

class AddClientDialog extends StatefulWidget {
  final ClientEntity? client;

  const AddClientDialog({super.key, this.client});

  @override
  State<AddClientDialog> createState() => _AddClientDialogState();
}

class _AddClientDialogState extends State<AddClientDialog> {
  final _formKey = GlobalKey<FormState>();

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

  String _selectedPlan = 'free';
  String _selectedBillingInterval = 'monthly';
  DateTime? _subscriptionStart;
  DateTime? _subscriptionEnd;

  final List<String> _plans = ['free', 'basic', 'premium', 'enterprise'];
  final List<String> _billingIntervals = ['monthly', 'quarterly', 'yearly'];

  @override
  void initState() {
    super.initState();
    if (widget.client != null) {
      _initializeWithClientData();
    } else {
      _initializeWithDefaults();
    }
  }

  void _initializeWithClientData() {
    final client = widget.client!;
    _nameController.text = client.name;
    _billingAmountController.text = client.billingAmount.toString();
    _selectedPlan = client.plan;
    _selectedBillingInterval = client.billingInterval;
    _subscriptionStart = client.subscriptionStart;
    _subscriptionEnd = client.subscriptionEnd;

    _subscriptionStartController.text =
        DateFormat('yyyy-MM-dd').format(client.subscriptionStart!);
    _subscriptionEndController.text =
        DateFormat('yyyy-MM-dd').format(client.subscriptionEnd!);

    _allowedBranchesController.text = client.allowedBranches.toString();
    _allowedUsersController.text = client.allowedUsers.toString();
  }

  void _initializeWithDefaults() {
    _subscriptionStart = DateTime.now();
    _subscriptionEnd = DateTime.now().add(const Duration(days: 365));
    _subscriptionStartController.text =
        DateFormat('yyyy-MM-dd').format(_subscriptionStart!);
    _subscriptionEndController.text =
        DateFormat('yyyy-MM-dd').format(_subscriptionEnd!);
    _billingAmountController.text = '0.00';
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
    final isEditing = widget.client != null;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: 600,
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    Icon(
                      isEditing ? Icons.edit : Icons.add_business,
                      color: Theme.of(context).primaryColor,
                      size: 28,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      isEditing ? 'Edit Client' : 'Create New Client',
                      style: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Basic Info
                Row(
                  children: [
                    Expanded(
                      child: CustomInput(
                        controller: _nameController,
                        label: 'Company Name',
                        hintText: 'Enter company name',
                        validator: (value) =>
                            value == null || value.isEmpty ? 'Required' : null,
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
                ),

                const SizedBox(height: 16),

                Row(
                  children: [
                    Expanded(
                      child: CustomInput(
                        controller: _phoneController,
                        label: 'Phone',
                        hintText: 'Enter phone number',
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: CustomInput(
                        controller: _websiteController,
                        label: 'Website',
                        hintText: 'Enter website URL',
                      ),
                    ),
                  ],
                ),

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

                // Plan & Billing
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _selectedPlan,
                        decoration: InputDecoration(
                          labelText: 'Plan',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8)),
                        ),
                        items: _plans
                            .map((p) => DropdownMenuItem(
                                  value: p,
                                  child: Text(p.toUpperCase()),
                                ))
                            .toList(),
                        onChanged: (val) =>
                            setState(() => _selectedPlan = val!),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: CustomInput(
                        controller: _billingAmountController,
                        label: 'Billing Amount',
                        hintText: '0.00',
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _selectedBillingInterval,
                        decoration: InputDecoration(
                          labelText: 'Billing Interval',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8)),
                        ),
                        items: _billingIntervals
                            .map((i) => DropdownMenuItem(
                                  value: i,
                                  child: Text(i.toUpperCase()),
                                ))
                            .toList(),
                        onChanged: (val) =>
                            setState(() => _selectedBillingInterval = val!),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: CustomInput(
                        controller: _allowedBranchesController,
                        label: 'Allowed Branches',
                        hintText: 'Number of branches',
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                CustomInput(
                  controller: _allowedUsersController,
                  label: 'Allowed Users',
                  hintText: 'Number of users',
                  keyboardType: TextInputType.number,
                ),

                const SizedBox(height: 16),

                // Subscription Dates
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
                      text: isEditing ? 'Update Client' : 'Create Client',
                      onPressed: _submitForm,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context, bool isStart) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isStart
          ? _subscriptionStart ?? DateTime.now()
          : _subscriptionEnd ?? DateTime.now(),
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

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final billingAmount = double.tryParse(_billingAmountController.text) ?? 0;

      if (widget.client != null) {
        context.read<ClientCubit>().updateClient(
              id: widget.client!.id,
              name: _nameController.text,
              plan: _selectedPlan,
              subscriptionStart: _subscriptionStart!,
              subscriptionEnd: _subscriptionEnd!,
              billingAmount: billingAmount,
              billingInterval: _selectedBillingInterval,
              allowedBranches: int.tryParse(_allowedBranchesController.text)!,
              allowedUsers: int.tryParse(_allowedUsersController.text)!,
            );
      } else {
        context.read<ClientCubit>().createClient(
              name: _nameController.text,
              plan: _selectedPlan,
              subscriptionStart: _subscriptionStart!,
              subscriptionEnd: _subscriptionEnd!,
              billingAmount: billingAmount,
              billingInterval: _selectedBillingInterval,
              allowedBranches:
                  int.tryParse(_allowedBranchesController.text) ?? 1,
              allowedUsers: int.tryParse(_allowedUsersController.text) ?? 5,
            );
      }
      Navigator.of(context).pop();
    }
  }
}
