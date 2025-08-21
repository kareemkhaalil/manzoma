import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:huma_plus/core/storage/shared_pref_helper.dart';
import 'package:intl/intl.dart';
import '../cubit/payroll_cubit.dart';
import '../cubit/payroll_state.dart';
import '../../../../shared/widgets/custom_button.dart';

class PayrollScreen extends StatelessWidget {
  const PayrollScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = SharedPrefHelper.getUser();
// لو مفيش يوزر، هيكون فاضي
    return BlocProvider(
      create: (context) => PayrollCubit(),
      child: const PayrollView(),
    );
  }
}

class PayrollView extends StatefulWidget {
  const PayrollView({super.key});

  @override
  State<PayrollView> createState() => _PayrollViewState();
}

class _PayrollViewState extends State<PayrollView> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      context.read<PayrollCubit>().getPayrollHistory(
            // userId: 'current-user-id',
            refresh: false,
          );
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Payroll Management',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                CustomButton(
                  text: 'Create Payroll',
                  onPressed: () => _showCreatePayrollDialog(context),
                  icon: Icons.add,
                ),
              ],
            ),
            const SizedBox(height: 32),

            // Summary Cards
            Row(
              children: [
                Expanded(
                  child: _buildSummaryCard(
                    'Total Salary',
                    '\$12,500',
                    Icons.attach_money,
                    Colors.green,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildSummaryCard(
                    'This Month',
                    '\$4,200',
                    Icons.calendar_month,
                    Colors.blue,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildSummaryCard(
                    'Pending',
                    '3 Records',
                    Icons.pending,
                    Colors.orange,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildSummaryCard(
                    'Paid',
                    '12 Records',
                    Icons.check_circle,
                    Colors.green,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),

            // Payroll History
            const Text(
              'Payroll History',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            Expanded(
              child: BlocConsumer<PayrollCubit, PayrollState>(
                listener: (context, state) {
                  if (state is PayrollCreateSuccess) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('تم إنشاء كشف الراتب بنجاح'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  } else if (state is PayrollError) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(state.message),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                builder: (context, state) {
                  if (state is PayrollLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is PayrollHistoryLoaded) {
                    return ListView.builder(
                      controller: _scrollController,
                      itemCount: state.payrollList.length +
                          (state.hasReachedMax ? 0 : 1),
                      itemBuilder: (context, index) {
                        if (index >= state.payrollList.length) {
                          return const Center(
                            child: Padding(
                              padding: EdgeInsets.all(16.0),
                              child: CircularProgressIndicator(),
                            ),
                          );
                        }

                        final payroll = state.payrollList[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          child: ExpansionTile(
                            leading: CircleAvatar(
                              backgroundColor: _getStatusColor(payroll.status),
                              child: Icon(
                                _getStatusIcon(payroll.status),
                                color: Colors.white,
                              ),
                            ),
                            title: Text(
                              'Payroll - ${payroll.period}',
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(
                              'Net Salary: \$${payroll.netSalary.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.green,
                              ),
                            ),
                            trailing: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: _getStatusColor(payroll.status)
                                    .withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                payroll.status.name.toUpperCase(),
                                style: TextStyle(
                                  color: _getStatusColor(payroll.status),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  children: [
                                    _buildPayrollDetailRow('Basic Salary',
                                        '\$${payroll.basicSalary.toStringAsFixed(2)}'),
                                    _buildPayrollDetailRow('Allowances',
                                        '\$${payroll.allowances.toStringAsFixed(2)}'),
                                    _buildPayrollDetailRow('Overtime',
                                        '\$${payroll.overtime.toStringAsFixed(2)}'),
                                    _buildPayrollDetailRow('Bonus',
                                        '\$${payroll.bonus.toStringAsFixed(2)}'),
                                    _buildPayrollDetailRow('Deductions',
                                        '-\$${payroll.deductions.toStringAsFixed(2)}'),
                                    const Divider(),
                                    _buildPayrollDetailRow('Net Salary',
                                        '\$${payroll.netSalary.toStringAsFixed(2)}',
                                        isTotal: true),
                                    const SizedBox(height: 8),
                                    _buildPayrollDetailRow('Working Days',
                                        '${payroll.actualWorkingDays}/${payroll.workingDays}'),
                                    if (payroll.notes != null)
                                      _buildPayrollDetailRow(
                                          'Notes', payroll.notes!),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  } else if (state is PayrollError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.error, size: 64, color: Colors.red),
                          const SizedBox(height: 16),
                          Text(state.message),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              context.read<PayrollCubit>().getPayrollHistory(
                                    refresh: true,
                                  );
                            },
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    );
                  }
                  return const Center(child: Text('No payroll data'));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard(
      String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: color, size: 24),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 16),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPayrollDetailRow(String label, String value,
      {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              fontSize: isTotal ? 16 : 14,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
              fontSize: isTotal ? 16 : 14,
              color: isTotal ? Colors.green : null,
            ),
          ),
        ],
      ),
    );
  }

  void _showCreatePayrollDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create New Payroll'),
        content: const Text(
            'This feature will open a form to create a new payroll record.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<PayrollCubit>().createPayroll(
                    // userId: 'current-user-id',
                    period: DateFormat('yyyy-MM').format(DateTime.now()),
                    basicSalary: 5000.0,
                    allowances: 500.0,
                    deductions: 200.0,
                    overtime: 300.0,
                    bonus: 100.0,
                    workingDays: 22,
                    actualWorkingDays: 20,
                    notes: 'Monthly payroll',
                  );
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(status) {
    switch (status.toString()) {
      case 'PayrollStatus.draft':
        return Colors.grey;
      case 'PayrollStatus.approved':
        return Colors.blue;
      case 'PayrollStatus.paid':
        return Colors.green;
      case 'PayrollStatus.cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(status) {
    switch (status.toString()) {
      case 'PayrollStatus.draft':
        return Icons.edit;
      case 'PayrollStatus.approved':
        return Icons.check;
      case 'PayrollStatus.paid':
        return Icons.payment;
      case 'PayrollStatus.cancelled':
        return Icons.cancel;
      default:
        return Icons.help;
    }
  }
}
