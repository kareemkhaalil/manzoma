import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:manzoma/core/storage/shared_pref_helper.dart';
import 'package:manzoma/features/payroll/domain/entities/payroll_detail_entity.dart';
import 'package:manzoma/features/payroll/domain/entities/payroll_entity.dart';
import 'package:manzoma/features/payroll/domain/entities/payroll_rules_entity.dart';
import 'package:manzoma/features/payroll/presentation/cubit/payroll_cubit.dart';
import 'package:manzoma/features/payroll/presentation/cubit/payroll_state.dart';

// Assuming PayrollRule, RuleType, CalculationMethod, Employee models are accessible
// For simplicity, including them here. In a real app, they would be imported.
// class PayrollRule {
//   final String id;
//   String name;
//   RuleType type;
//   CalculationMethod calcMethod;
//   double value;
//   String? description;
//   bool isAutomatic;
//   String? customFormula;
//   PayrollRule(
//       {required this.id,
//       required this.name,
//       required this.type,
//       required this.calcMethod,
//       required this.value,
//       this.description,
//       this.isAutomatic = false,
//       this.customFormula});
// }

// enum RuleType { allowance, deduction }

// enum CalculationMethod { fixed, percentage, perHour, custom }

// class Employee {
//   final String id;
//   final String name;
//   final double basicSalary;
//   Employee({required this.id, required this.name, required this.basicSalary});
// }

// class AttendanceData {
//   final String employeeId;
//   final double overtimeHours;
//   final int absenceDays;
//   AttendanceData(
//       {required this.employeeId,
//       required this.overtimeHours,
//       required this.absenceDays});
// }

// class EmployeeSalaryScreen extends StatefulWidget {
//   const EmployeeSalaryScreen({super.key});

//   @override
//   State<EmployeeSalaryScreen> createState() => _EmployeeSalaryScreenState();
// }

// class _EmployeeSalaryScreenState extends State<EmployeeSalaryScreen> {
//   // Mock data
//   final List<Employee> _employees = [
//     Employee(id: '101', name: 'أحمد محمود', basicSalary: 8500),
//     Employee(id: '102', name: 'فاطمة الزهراء', basicSalary: 9000),
//     Employee(id: '103', name: 'كريم عبد العزيز', basicSalary: 7000),
//   ];
//   final List<PayrollRule> _allRules = [
//     PayrollRule(
//         id: '1',
//         name: 'بدل مواصلات',
//         type: RuleType.allowance,
//         calcMethod: CalculationMethod.fixed,
//         value: 500,
//         isAutomatic: true),
//     PayrollRule(
//         id: '2',
//         name: 'خصم تأمينات',
//         type: RuleType.deduction,
//         calcMethod: CalculationMethod.percentage,
//         value: 11,
//         isAutomatic: true),
//     PayrollRule(
//         id: '3',
//         name: 'مكافأة أداء',
//         type: RuleType.allowance,
//         calcMethod: CalculationMethod.fixed,
//         value: 1000,
//         isAutomatic: false),
//     PayrollRule(
//         id: '4',
//         name: 'خصم غياب',
//         type: RuleType.deduction,
//         calcMethod: CalculationMethod.custom,
//         value: 0,
//         isAutomatic: true,
//         customFormula: '(basicSalary / 30) * absenceDays'),
//     PayrollRule(
//         id: '5',
//         name: 'بدل سكن',
//         type: RuleType.allowance,
//         calcMethod: CalculationMethod.fixed,
//         value: 800,
//         isAutomatic: true),
//     PayrollRule(
//         id: '6',
//         name: 'عمل إضافي',
//         type: RuleType.allowance,
//         calcMethod: CalculationMethod.perHour,
//         value: 50,
//         isAutomatic: true),
//   ];
//   final List<AttendanceData> _attendanceData = [
//     AttendanceData(employeeId: '101', overtimeHours: 10, absenceDays: 2),
//     AttendanceData(employeeId: '102', overtimeHours: 5, absenceDays: 0),
//     AttendanceData(employeeId: '103', overtimeHours: 0, absenceDays: 1),
//   ];

//   Employee? _selectedEmployee;
//   final _basicSalaryController = TextEditingController();
//   final Set<String> _assignedRuleIds = {};

//   // State for ExpansionPanels
//   bool _isAllowancesExpanded = true;
//   bool _isDeductionsExpanded = false;

//   // Semantic Colors
//   static const Color successColor = Color(0xFF10B981);
//   static const Color errorColor = Color(0xFFEF4444);

//   @override
//   void initState() {
//     super.initState();
//     _basicSalaryController.addListener(() => setState(() {}));
//   }

//   @override
//   void dispose() {
//     _basicSalaryController.dispose();
//     super.dispose();
//   }

//   void _onEmployeeSelected(Employee? employee) {
//     if (employee == null) return;
//     setState(() {
//       _selectedEmployee = employee;
//       _basicSalaryController.text = employee.basicSalary.toString();
//       _assignedRuleIds.clear();
//       _assignedRuleIds
//           .addAll(_allRules.where((r) => r.isAutomatic).map((r) => r.id));
//     });
//   }

//   // A simplified calculation for demonstration
//   Map<String, double> _calculateTotals() {
//     if (_selectedEmployee == null)
//       return {'additions': 0, 'deductions': 0, 'net': 0};
//     double basicSalary = double.tryParse(_basicSalaryController.text) ?? 0.0;
//     double totalAdditions = 0;
//     double totalDeductions = 0;

//     // In a real app, calculation logic would be more robust
//     for (var ruleId in _assignedRuleIds) {
//       final rule = _allRules.firstWhere((r) => r.id == ruleId);
//       double amount = 0;
//       if (rule.calcMethod == CalculationMethod.percentage) {
//         amount = basicSalary * (rule.value / 100);
//       } else {
//         amount = rule.value;
//       }

//       if (rule.type == RuleType.allowance) {
//         totalAdditions += amount;
//       } else {
//         totalDeductions += amount;
//       }
//     }

//     return {
//       'additions': totalAdditions,
//       'deductions': totalDeductions,
//       'net': basicSalary + totalAdditions - totalDeductions,
//     };
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('إعداد هيكل الراتب'),
//         centerTitle: true,
//       ),
//       body: LayoutBuilder(
//         builder: (context, constraints) {
//           bool isWideScreen = constraints.maxWidth > 800;
//           final totals = _calculateTotals();

//           if (isWideScreen) {
//             return Row(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Expanded(
//                   flex: 2,
//                   child: _buildEmployeeSetupForm(),
//                 ),
//                 const VerticalDivider(width: 1),
//                 Expanded(
//                   flex: 3,
//                   child: SingleChildScrollView(
//                     padding: const EdgeInsets.all(16),
//                     child: Column(
//                       children: [
//                         _buildSalarySummaryCard(totals),
//                         const SizedBox(height: 16),
//                         _buildRulesExpansionPanel(),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             );
//           } else {
//             // Mobile Layout
//             return SingleChildScrollView(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 children: [
//                   _buildEmployeeSetupForm(),
//                   const SizedBox(height: 24),
//                   _buildSalarySummaryCard(totals),
//                   const SizedBox(height: 16),
//                   _buildRulesExpansionPanel(),
//                 ],
//               ),
//             );
//           }
//         },
//       ),
//       bottomNavigationBar: _buildActionButtons(),
//     );
//   }

//   Widget _buildEmployeeSetupForm() {
//     return Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text('1. اختر الموظف والراتب الأساسي',
//               style: Theme.of(context).textTheme.titleLarge),
//           const SizedBox(height: 16),
//           DropdownButtonFormField<Employee>(
//             value: _selectedEmployee,
//             hint: const Text('اختر موظفًا...'),
//             decoration: const InputDecoration(labelText: 'الموظف'),
//             items: _employees.map((employee) {
//               return DropdownMenuItem(
//                   value: employee, child: Text(employee.name));
//             }).toList(),
//             onChanged: _onEmployeeSelected,
//           ),
//           const SizedBox(height: 16),
//           if (_selectedEmployee != null)
//             TextFormField(
//               controller: _basicSalaryController,
//               decoration: const InputDecoration(
//                 labelText: 'الراتب الأساسي',
//                 suffixText: 'EGP',
//               ),
//               keyboardType: TextInputType.number,
//             ),
//         ],
//       ),
//     );
//   }

//   Widget _buildSalarySummaryCard(Map<String, double> totals) {
//     return Card(
//       elevation: 4,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       color: Theme.of(context).primaryColor.withOpacity(0.05),
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text('ملخص الراتب', style: Theme.of(context).textTheme.titleLarge),
//             const SizedBox(height: 16),
//             _summaryRow('الراتب الأساسي',
//                 '${double.tryParse(_basicSalaryController.text) ?? 0.0} EGP'),
//             _summaryRow('إجمالي الإضافات',
//                 '${totals['additions']?.toStringAsFixed(2)} EGP',
//                 color: successColor),
//             _summaryRow('إجمالي الخصومات',
//                 '${totals['deductions']?.toStringAsFixed(2)} EGP',
//                 color: errorColor),
//             const Divider(height: 24),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text('صافي الراتب النهائي',
//                     style: Theme.of(context)
//                         .textTheme
//                         .titleMedium
//                         ?.copyWith(fontWeight: FontWeight.bold)),
//                 Text('${totals['net']?.toStringAsFixed(2)} EGP',
//                     style: Theme.of(context).textTheme.titleLarge?.copyWith(
//                         fontWeight: FontWeight.bold,
//                         color: Theme.of(context).primaryColor)),
//               ],
//             )
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _summaryRow(String title, String value, {Color? color}) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 4.0),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(title, style: Theme.of(context).textTheme.bodyMedium),
//           Text(value,
//               style: TextStyle(fontWeight: FontWeight.bold, color: color)),
//         ],
//       ),
//     );
//   }

//   Widget _buildRulesExpansionPanel() {
//     final allowances =
//         _allRules.where((r) => r.type == RuleType.allowance).toList();
//     final deductions =
//         _allRules.where((r) => r.type == RuleType.deduction).toList();

//     return ExpansionPanelList(
//       elevation: 2,
//       expansionCallback: (panelIndex, isExpanded) {
//         setState(() {
//           if (panelIndex == 0) _isAllowancesExpanded = !isExpanded;
//           if (panelIndex == 1) _isDeductionsExpanded = !isExpanded;
//         });
//       },
//       children: [
//         ExpansionPanel(
//           headerBuilder: (context, isExpanded) => ListTile(
//             title: Text('2. البدلات والإضافات (${allowances.length})',
//                 style: Theme.of(context).textTheme.titleMedium),
//           ),
//           body: Column(
//             children: allowances.map(_buildRuleCheckbox).toList(),
//           ),
//           isExpanded: _isAllowancesExpanded,
//         ),
//         ExpansionPanel(
//           headerBuilder: (context, isExpanded) => ListTile(
//             title: Text('3. الخصومات (${deductions.length})',
//                 style: Theme.of(context).textTheme.titleMedium),
//           ),
//           body: Column(
//             children: deductions.map(_buildRuleCheckbox).toList(),
//           ),
//           isExpanded: _isDeductionsExpanded,
//         ),
//       ],
//     );
//   }

//   Widget _buildRuleCheckbox(PayrollRule rule) {
//     return CheckboxListTile(
//       title: Text(rule.name),
//       subtitle: Text(rule.description ?? '...'),
//       value: _assignedRuleIds.contains(rule.id),
//       onChanged: rule.isAutomatic
//           ? null
//           : (selected) {
//               setState(() {
//                 if (selected == true) {
//                   _assignedRuleIds.add(rule.id);
//                 } else {
//                   _assignedRuleIds.remove(rule.id);
//                 }
//               });
//             },
//       activeColor: rule.type == RuleType.allowance ? successColor : errorColor,
//       controlAffinity: ListTileControlAffinity.leading,
//     );
//   }

//   Widget _buildActionButtons() {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Theme.of(context).scaffoldBackgroundColor,
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.1),
//             blurRadius: 10,
//             offset: const Offset(0, -4),
//           )
//         ],
//       ),
//       child: Row(
//         children: [
//           Expanded(
//             child: OutlinedButton(
//               onPressed: () {},
//               child: const Text('إلغاء'),
//             ),
//           ),
//           const SizedBox(width: 16),
//           Expanded(
//             child: ElevatedButton.icon(
//               icon: const Icon(
//                 Icons.save_alt_rounded,
//                 color: Colors.white,
//               ),
//               label: const Text(
//                 'حفظ الهيكل',
//                 style: TextStyle(color: Colors.white),
//               ),
//               onPressed: _selectedEmployee == null ? null : () {},
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Theme.of(context).primaryColor,
//                 padding: const EdgeInsets.symmetric(vertical: 12),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
class EmployeeSalaryScreen extends StatefulWidget {
  final String payrollId;
  const EmployeeSalaryScreen({super.key, required this.payrollId});

  @override
  State<EmployeeSalaryScreen> createState() => _EmployeeSalaryScreenState();
}

class _EmployeeSalaryScreenState extends State<EmployeeSalaryScreen> {
  PayrollRuleEntity? selectedRule;
  final user = SharedPrefHelper.getUser();

  @override
  void initState() {
    super.initState();
    final cubit = context.read<PayrollCubit>();
    cubit.fetchPayrollById(widget.payrollId);
    if (user != null) cubit.fetchRules(user!.tenantId);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PayrollCubit, PayrollState>(
      builder: (context, state) {
        if (state.status == PayrollStatus.loading ||
            state.selectedPayroll == null) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final payroll = state.selectedPayroll!;
        final details = state.details;
        final rules = state.rules;

        final totalAdditions = details
            .where((d) => d.type == 'allowance')
            .fold(0.0, (sum, d) => sum + d.amount);
        final totalDeductions = details
            .where((d) => d.type == 'deduction')
            .fold(0.0, (sum, d) => sum + d.amount);
        final net = payroll.basicSalary + totalAdditions - totalDeductions;

        return Scaffold(
          appBar: AppBar(
            title: Text("تفاصيل راتب - ${payroll.userName}"),
            centerTitle: true,
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                _buildSummaryCard(
                    payroll.basicSalary, totalAdditions, totalDeductions, net),
                const SizedBox(height: 16),
                Expanded(
                  child: ListView(
                    children: [
                      Text("القواعد المطبقة",
                          style: Theme.of(context).textTheme.titleMedium),
                      const SizedBox(height: 8),
                      ...details.map((d) => ListTile(
                            leading: Icon(
                              d.type == 'allowance'
                                  ? Icons.add_circle
                                  : Icons.remove_circle,
                              color: d.type == 'allowance'
                                  ? Colors.green
                                  : Colors.red,
                            ),
                            title: Text(d.ruleName),
                            subtitle: Text(
                                "${d.amount.toStringAsFixed(2)} EGP (${d.type})"),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                context.read<PayrollCubit>().removeDetail(d.id);
                              },
                            ),
                          )),
                      const Divider(),
                      Text("إضافة قاعدة جديدة",
                          style: Theme.of(context).textTheme.titleMedium),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<PayrollRuleEntity>(
                        value: selectedRule,
                        hint: const Text("اختر قاعدة"),
                        items: rules
                            .map((r) => DropdownMenuItem(
                                  value: r,
                                  child: Text(r.name),
                                ))
                            .toList(),
                        onChanged: (val) => setState(() => selectedRule = val),
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.add),
                        label: const Text("تطبيق القاعدة"),
                        onPressed: selectedRule == null
                            ? null
                            : () {
                                final rule = selectedRule!;
                                final detail = PayrollDetailEntity(
                                  tenantId: user!.tenantId,
                                  id: DateTime.now()
                                      .microsecondsSinceEpoch
                                      .toString(),
                                  payrollId: payroll.id,
                                  ruleName: rule.name,
                                  type: rule.type,
                                  calculationMethod: rule.calculationMethod,
                                  amount: _calculateAmount(
                                      rule, payroll.basicSalary),
                                  createdAt: DateTime.now(),
                                );
                                context.read<PayrollCubit>().addDetail(detail);
                              },
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSummaryCard(
      double basic, double additions, double deductions, double netSalary) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _row("الراتب الأساسي", "${basic.toStringAsFixed(2)} EGP"),
            _row("الإضافات", "${additions.toStringAsFixed(2)} EGP",
                color: Colors.green),
            _row("الخصومات", "${deductions.toStringAsFixed(2)} EGP",
                color: Colors.red),
            const Divider(),
            _row("الصافي النهائي", "${netSalary.toStringAsFixed(2)} EGP",
                bold: true),
          ],
        ),
      ),
    );
  }

  Widget _row(String title, String value, {Color? color, bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontWeight: bold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  double _calculateAmount(PayrollRuleEntity rule, double basicSalary) {
    switch (rule.calculationMethod) {
      case "fixed":
        return rule.value;
      case "percentage":
        return (basicSalary * rule.value / 100);
      case "per_hour":
        return 0;
      case "custom":
        return 0;
      default:
        return 0;
    }
  }
}
