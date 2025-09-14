import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// Mock data models (as they were in the original file)
class Employee {
  final String id;
  final String name;
  final double basicSalary;

  Employee({required this.id, required this.name, required this.basicSalary});
}

class Payroll {
  final String id;
  final String employeeId;
  final String employeeName;
  final double basicSalary;
  final double totalAllowances;
  final double totalDeductions;
  final double netSalary;
  final String status; // Draft, Approved, Paid
  final DateTime month;

  Payroll({
    required this.id,
    required this.employeeId,
    required this.employeeName,
    required this.basicSalary,
    required this.totalAllowances,
    required this.totalDeductions,
    required this.netSalary,
    required this.status,
    required this.month,
  });
}

class PayrollScreen extends StatefulWidget {
  const PayrollScreen({super.key});

  @override
  State<PayrollScreen> createState() => _PayrollScreenState();
}

class _PayrollScreenState extends State<PayrollScreen> {
  // Mock data
  final List<Payroll> _payrolls = [
    Payroll(
      id: '1',
      employeeId: '101',
      employeeName: 'أحمد محمود',
      basicSalary: 8500,
      totalAllowances: 1300,
      totalDeductions: 935,
      netSalary: 8865,
      status: 'Paid',
      month: DateTime(2025, 9),
    ),
    Payroll(
      id: '2',
      employeeId: '102',
      employeeName: 'فاطمة الزهراء',
      basicSalary: 9000,
      totalAllowances: 1800,
      totalDeductions: 990,
      netSalary: 9810,
      status: 'Approved',
      month: DateTime(2025, 9),
    ),
    Payroll(
      id: '3',
      employeeId: '103',
      employeeName: 'كريم عبد العزيز',
      basicSalary: 7000,
      totalAllowances: 500,
      totalDeductions: 770,
      netSalary: 6730,
      status: 'Draft',
      month: DateTime(2025, 9),
    ),
  ];

  DateTime _selectedMonth = DateTime(2025, 9);
  String _filterStatus = 'All';

  List<Payroll> get _filteredPayrolls {
    return _payrolls.where((payroll) {
      final monthMatch = payroll.month.year == _selectedMonth.year &&
          payroll.month.month == _selectedMonth.month;
      final statusMatch =
          _filterStatus == 'All' || payroll.status == _filterStatus;
      return monthMatch && statusMatch;
    }).toList();
  }

  // Semantic Colors for UI elements
  static const Color successColor = Color(0xFF10B981);
  static const Color warningColor = Color(0xFFF59E0B);
  static const Color infoColor = Color(0xFF6366F1);
  static const Color errorColor = Color(0xFFEF4444);

  @override
  Widget build(BuildContext context) {
    // Summary calculations
    final totalPaid = _payrolls
        .where((p) => p.status == 'Paid')
        .fold(0.0, (sum, p) => sum + p.netSalary);
    final totalExpected = _payrolls.fold(0.0, (sum, p) => sum + p.netSalary);
    final employeeCount = _payrolls.map((p) => p.employeeId).toSet().length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('لوحة تحكم الرواتب'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'ملخص رواتب شهر سبتمبر 2025',
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildSummaryGrid(totalPaid, totalExpected, employeeCount),
            const SizedBox(height: 24),
            _buildFilterSection(),
            const SizedBox(height: 24),
            Text(
              'تقرير الرواتب المفصل',
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            _buildPayrollDataTable(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('جاري إنشاء كشوفات الرواتب...'),
              backgroundColor: successColor,
            ),
          );
        },
        tooltip: 'إنشاء كشوفات رواتب الشهر',
        icon: const Icon(Icons.add),
        label: const Text('إنشاء الرواتب'),
        backgroundColor: successColor,
      ),
    );
  }

  Widget _buildSummaryGrid(
      double totalPaid, double totalExpected, int employeeCount) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Use GridView for responsiveness
        return GridView.count(
          crossAxisCount: constraints.maxWidth > 600 ? 4 : 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 2.5,
          children: [
            _buildSummaryCard(
              title: 'إجمالي المدفوع',
              value: '${totalPaid.toStringAsFixed(2)} EGP',
              icon: Icons.check_circle_outline,
              color: successColor,
            ),
            _buildSummaryCard(
              title: 'الإجمالي المتوقع',
              value: '${totalExpected.toStringAsFixed(2)} EGP',
              icon: Icons.account_balance_wallet_outlined,
              color: infoColor,
            ),
            _buildSummaryCard(
              title: 'عدد الموظفين',
              value: '$employeeCount',
              icon: Icons.people_outline,
              color: warningColor,
            ),
            _buildSummaryCard(
              title: 'مسودات',
              value:
                  _payrolls.where((p) => p.status == 'Draft').length.toString(),
              icon: Icons.drafts_outlined,
              color: Colors.grey.shade600,
            ),
          ],
        );
      },
    );
  }

  Widget _buildSummaryCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 20),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: color,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterSection() {
    return Card(
      elevation: 0,
      color: Colors.grey.shade50,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Row(
          children: [
            Expanded(
              child: DropdownButtonFormField<String>(
                value: _filterStatus,
                decoration: const InputDecoration(
                  labelText: 'فلترة حسب الحالة',
                  border: InputBorder.none,
                  filled: false,
                ),
                items: const [
                  DropdownMenuItem(value: 'All', child: Text('الكل')),
                  DropdownMenuItem(value: 'Draft', child: Text('مسودة')),
                  DropdownMenuItem(value: 'Approved', child: Text('معتمد')),
                  DropdownMenuItem(value: 'Paid', child: Text('مدفوع')),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _filterStatus = value);
                  }
                },
              ),
            ),
            const SizedBox(width: 16),
            TextButton.icon(
              icon: const Icon(Icons.calendar_today_outlined),
              label: Text('${_selectedMonth.month}/${_selectedMonth.year}'),
              onPressed: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: _selectedMonth,
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2030),
                  initialEntryMode: DatePickerEntryMode.calendarOnly,
                );
                if (picked != null) {
                  setState(() => _selectedMonth = picked);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPayrollDataTable() {
    return SizedBox(
      width: double.infinity,
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: DataTable(
          columns: const [
            DataColumn(label: Text('اسم الموظف')),
            DataColumn(label: Text('صافي الراتب'), numeric: true),
            DataColumn(label: Text('الحالة')),
            DataColumn(label: Text('إجراءات')),
          ],
          rows: _filteredPayrolls.map((payroll) {
            return DataRow(
              cells: [
                DataCell(Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(payroll.employeeName,
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    Text(
                        'الأساسي: ${payroll.basicSalary.toStringAsFixed(0)} EGP'),
                  ],
                )),
                DataCell(Text(
                  '${payroll.netSalary.toStringAsFixed(2)} EGP',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, color: successColor),
                )),
                DataCell(_buildStatusChip(payroll.status)),
                DataCell(
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.visibility_outlined,
                            color: infoColor),
                        onPressed: () {},
                        tooltip: 'عرض التفاصيل',
                      ),
                      IconButton(
                        icon: const Icon(Icons.print_outlined,
                            color: warningColor),
                        onPressed: () {},
                        tooltip: 'طباعة القسيمة',
                      ),
                    ],
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    Color color;
    String label;
    switch (status) {
      case 'Paid':
        color = successColor;
        label = 'مدفوع';
        break;
      case 'Approved':
        color = infoColor;
        label = 'معتمد';
        break;
      case 'Draft':
        color = Colors.grey.shade600;
        label = 'مسودة';
        break;
      default:
        color = Colors.black;
        label = 'غير معروف';
    }
    return Chip(
      label: Text(label,
          style: const TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold)),
      backgroundColor: color,
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      labelPadding: const EdgeInsets.symmetric(horizontal: 4.0),
      visualDensity: VisualDensity.compact,
    );
  }
}
