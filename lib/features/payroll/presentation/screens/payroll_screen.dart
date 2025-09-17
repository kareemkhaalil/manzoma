// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:manzoma/features/payroll/presentation/cubit/payroll_cubit.dart';
// import 'package:manzoma/features/payroll/presentation/cubit/payroll_state.dart';
// import 'package:manzoma/features/payroll/domain/entities/payroll_entity.dart';

// class PayrollScreen extends StatefulWidget {
//   const PayrollScreen({super.key});

//   @override
//   State<PayrollScreen> createState() => _PayrollScreenState();
// }

// class _PayrollScreenState extends State<PayrollScreen> {
//   DateTime _selectedMonth = DateTime.now();
//   String _filterStatus = 'All';

//   List<PayrollEntity> _filterPayrolls(
//       List<PayrollEntity> payrolls, PayrollState state) {
//     return payrolls.where((p) {
//       final monthMatch = p.periodStart.year == _selectedMonth.year &&
//           p.periodStart.month == _selectedMonth.month;
//       final statusMatch = _filterStatus == 'All' || p.status == _filterStatus;
//       return monthMatch && statusMatch;
//     }).toList();
//   }

//   // Colors
//   static const Color successColor = Color(0xFF10B981);
//   static const Color warningColor = Color(0xFFF59E0B);
//   static const Color infoColor = Color(0xFF6366F1);

//   @override
//   void initState() {
//     super.initState();
//     // Fetch payrolls أول ما الصفحة تفتح
//     context.read<PayrollCubit>().fetchPayrolls("tenant-1");
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('لوحة تحكم الرواتب'),
//         centerTitle: true,
//       ),
//       body: BlocBuilder<PayrollCubit, PayrollState>(
//         builder: (context, state) {
//           if (state.status == PayrollStatus.loading) {
//             return const Center(child: CircularProgressIndicator());
//           }

//           if (state.status == PayrollStatus.failure) {
//             return Center(
//               child: Text(state.errorMessage ?? "حصل خطأ"),
//             );
//           }

//           final payrolls = _filterPayrolls(state.payrolls, state);

//           // Summary calculations
//           final totalPaid = state.payrolls
//               .where((p) => p.status == 'paid')
//               .fold(0.0, (sum, p) => sum + p.netSalary.toDouble());
//           final totalExpected = state.payrolls
//               .fold(0.0, (sum, p) => sum + p.netSalary.toDouble());
//           final employeeCount =
//               state.payrolls.map((p) => p.userId).toSet().length;

//           return SingleChildScrollView(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   'ملخص رواتب ${_selectedMonth.month}/${_selectedMonth.year}',
//                   style: Theme.of(context)
//                       .textTheme
//                       .headlineSmall
//                       ?.copyWith(fontWeight: FontWeight.bold),
//                 ),
//                 const SizedBox(height: 16),
//                 _buildSummaryGrid(totalPaid, totalExpected, employeeCount),
//                 const SizedBox(height: 24),
//                 _buildFilterSection(),
//                 const SizedBox(height: 24),
//                 Text(
//                   'تقرير الرواتب المفصل',
//                   style: Theme.of(context)
//                       .textTheme
//                       .headlineSmall
//                       ?.copyWith(fontWeight: FontWeight.bold),
//                 ),
//                 const SizedBox(height: 8),
//                 _buildPayrollDataTable(payrolls),
//               ],
//             ),
//           );
//         },
//       ),
//       floatingActionButton: FloatingActionButton.extended(
//         onPressed: () {
//           // مثال: تضيف Payroll جديد
//           final payroll = PayrollEntity(
//             id: "new-id",
//             tenantId: "tenant-1",
//             userId: "user-1",
//             userName: "موظف جديد",
//             period: "2025-09",
//             periodStart: DateTime(2025, 9, 1),
//             periodEnd: DateTime(2025, 9, 30),
//             basicSalary: 5000,
//             gross: 5200,
//             netSalary: 4800,
//             workingDays: 22,
//             actualWorkingDays: 20,
//             status: "draft",
//             notes: "تمت الإضافة من الـFAB",
//             createdAt: DateTime.now(),
//             updatedAt: DateTime.now(),
//           );

//           context.read<PayrollCubit>().addPayroll(payroll);
//         },
//         tooltip: 'إنشاء كشوفات رواتب الشهر',
//         icon: const Icon(Icons.add),
//         label: const Text('إنشاء الرواتب'),
//         backgroundColor: successColor,
//       ),
//     );
//   }

//   Widget _buildSummaryGrid(
//       double totalPaid, double totalExpected, int employeeCount) {
//     return LayoutBuilder(
//       builder: (context, constraints) {
//         return GridView.count(
//           crossAxisCount: constraints.maxWidth > 600 ? 4 : 2,
//           shrinkWrap: true,
//           physics: const NeverScrollableScrollPhysics(),
//           crossAxisSpacing: 16,
//           mainAxisSpacing: 16,
//           childAspectRatio: 2.5,
//           children: [
//             _buildSummaryCard(
//               title: 'إجمالي المدفوع',
//               value: '${totalPaid.toStringAsFixed(2)} EGP',
//               icon: Icons.check_circle_outline,
//               color: successColor,
//             ),
//             _buildSummaryCard(
//               title: 'الإجمالي المتوقع',
//               value: '${totalExpected.toStringAsFixed(2)} EGP',
//               icon: Icons.account_balance_wallet_outlined,
//               color: infoColor,
//             ),
//             _buildSummaryCard(
//               title: 'عدد الموظفين',
//               value: '$employeeCount',
//               icon: Icons.people_outline,
//               color: warningColor,
//             ),
//             _buildSummaryCard(
//               title: 'مسودات',
//               value: employeeCount.toString(),
//               icon: Icons.drafts_outlined,
//               color: Colors.grey.shade600,
//             ),
//           ],
//         );
//       },
//     );
//   }

//   Widget _buildSummaryCard({
//     required String title,
//     required String value,
//     required IconData icon,
//     required Color color,
//   }) {
//     return Card(
//       elevation: 2,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: Padding(
//         padding: const EdgeInsets.all(12.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Row(
//               children: [
//                 Icon(icon, color: color, size: 20),
//                 const SizedBox(width: 8),
//                 Text(
//                   title,
//                   style: Theme.of(context).textTheme.bodySmall,
//                 ),
//               ],
//             ),
//             const SizedBox(height: 8),
//             Text(
//               value,
//               style: Theme.of(context).textTheme.titleLarge?.copyWith(
//                     color: color,
//                     fontWeight: FontWeight.bold,
//                   ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildFilterSection() {
//     return Card(
//       elevation: 0,
//       color: Colors.grey.shade50,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
//         child: Row(
//           children: [
//             Expanded(
//               child: DropdownButtonFormField<String>(
//                 value: _filterStatus,
//                 decoration: const InputDecoration(
//                   labelText: 'فلترة حسب الحالة',
//                   border: InputBorder.none,
//                   filled: false,
//                 ),
//                 items: const [
//                   DropdownMenuItem(value: 'All', child: Text('الكل')),
//                   DropdownMenuItem(value: 'draft', child: Text('مسودة')),
//                   DropdownMenuItem(value: 'approved', child: Text('معتمد')),
//                   DropdownMenuItem(value: 'paid', child: Text('مدفوع')),
//                 ],
//                 onChanged: (value) {
//                   if (value != null) {
//                     setState(() => _filterStatus = value);
//                   }
//                 },
//               ),
//             ),
//             const SizedBox(width: 16),
//             TextButton.icon(
//               icon: const Icon(Icons.calendar_today_outlined),
//               label: Text('${_selectedMonth.month}/${_selectedMonth.year}'),
//               onPressed: () async {
//                 final picked = await showDatePicker(
//                   context: context,
//                   initialDate: _selectedMonth,
//                   firstDate: DateTime(2020),
//                   lastDate: DateTime(2030),
//                   initialEntryMode: DatePickerEntryMode.calendarOnly,
//                 );
//                 if (picked != null) {
//                   setState(() => _selectedMonth = picked);
//                 }
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildPayrollDataTable(List<PayrollEntity> payrolls) {
//     return SizedBox(
//       width: double.infinity,
//       child: Card(
//         elevation: 2,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//         child: DataTable(
//           columns: const [
//             DataColumn(label: Text('اسم الموظف')),
//             DataColumn(label: Text('صافي الراتب'), numeric: true),
//             DataColumn(label: Text('الحالة')),
//           ],
//           rows: payrolls.map((p) {
//             return DataRow(
//               cells: [
//                 DataCell(Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Text(p.userName,
//                         style: const TextStyle(fontWeight: FontWeight.bold)),
//                     Text('الأساسي: ${p.basicSalary} EGP'),
//                   ],
//                 )),
//                 DataCell(Text(
//                   '${p.netSalary} EGP',
//                   style: const TextStyle(
//                       fontWeight: FontWeight.bold, color: successColor),
//                 )),
//                 DataCell(_buildStatusChip(p.status)),
//               ],
//             );
//           }).toList(),
//         ),
//       ),
//     );
//   }

//   Widget _buildStatusChip(String status) {
//     Color color;
//     String label;
//     switch (status) {
//       case 'paid':
//         color = successColor;
//         label = 'مدفوع';
//         break;
//       case 'approved':
//         color = infoColor;
//         label = 'معتمد';
//         break;
//       case 'draft':
//         color = Colors.grey.shade600;
//         label = 'مسودة';
//         break;
//       default:
//         color = Colors.black;
//         label = 'غير معروف';
//     }
//     return Chip(
//       label: Text(label,
//           style: const TextStyle(
//               color: Colors.white, fontWeight: FontWeight.bold)),
//       backgroundColor: color,
//       padding: const EdgeInsets.symmetric(horizontal: 4.0),
//       labelPadding: const EdgeInsets.symmetric(horizontal: 4.0),
//       visualDensity: VisualDensity.compact,
//     );
//   }
// }

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:manzoma/core/enums/user_role.dart';
import 'package:manzoma/core/storage/shared_pref_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:manzoma/features/payroll/domain/entities/payroll_entity.dart';
import 'package:manzoma/features/payroll/presentation/cubit/payroll_cubit.dart';
import 'package:manzoma/features/payroll/presentation/cubit/payroll_state.dart';
import 'package:manzoma/features/clients/presentation/cubit/client_cubit.dart';
import 'package:manzoma/features/clients/presentation/cubit/client_state.dart';
import 'package:manzoma/features/auth/data/models/user_model.dart';

class PayrollScreen extends StatefulWidget {
  const PayrollScreen({super.key});

  @override
  State<PayrollScreen> createState() => _PayrollScreenState();
}

class _PayrollScreenState extends State<PayrollScreen> {
  final DateTime _selectedMonth = DateTime.now();
  String _filterStatus = 'All';

  bool _isSuperAdmin = false;
  String? _tenantId;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final user = SharedPrefHelper.getUser();
    if (user == null) return;

    if (user.role == UserRole.superAdmin) {
      setState(() => _isSuperAdmin = true);
      context.read<ClientCubit>().getClients();
    } else {
      setState(() => _tenantId = user.tenantId);
      print(user.tenantId);
      print(user.name);
      print(user.role);

      context.read<PayrollCubit>().fetchPayrolls(user.tenantId);
    }
  }

  List<PayrollEntity> _filterPayrolls(List<PayrollEntity> payrolls) {
    return payrolls.where((p) {
      final monthMatch = p.periodStart.year == _selectedMonth.year &&
          p.periodStart.month == _selectedMonth.month;
      final statusMatch = _filterStatus == 'All' || p.status == _filterStatus;
      return monthMatch && statusMatch;
    }).toList();
  }

  // Colors
  static const Color successColor = Color(0xFF10B981);
  static const Color warningColor = Color(0xFFF59E0B);
  static const Color infoColor = Color(0xFF6366F1);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("لوحة تحكم الرواتب"),
        centerTitle: true,
        bottom: _isSuperAdmin
            ? PreferredSize(
                preferredSize: const Size.fromHeight(60),
                child: BlocBuilder<ClientCubit, ClientState>(
                  builder: (context, state) {
                    if (state is ClientLoading) {
                      return const LinearProgressIndicator();
                    }
                    if (state is ClientsLoaded) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: DropdownButtonFormField<String>(
                          value: _tenantId,
                          hint: const Text("اختر العميل"),
                          onChanged: (value) {
                            setState(() => _tenantId = value);
                            if (value != null) {
                              context.read<PayrollCubit>().fetchPayrolls(value);
                            }
                          },
                          items: state.clients
                              .map((c) => DropdownMenuItem(
                                    value: c.id,
                                    child: Text(c.name),
                                  ))
                              .toList(),
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              )
            : null,
      ),
      body: _tenantId == null
          ? const Center(child: Text("برجاء اختيار العميل"))
          : BlocBuilder<PayrollCubit, PayrollState>(
              builder: (context, state) {
                if (state.status == PayrollStatus.loading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state.status == PayrollStatus.failure) {
                  return Center(child: Text(state.errorMessage ?? "حصل خطأ"));
                }

                final payrolls = _filterPayrolls(state.payrolls);

                final totalPaid = payrolls
                    .where((p) => p.status == 'paid')
                    .fold(0.0, (sum, p) => sum + p.netSalary.toDouble());

                final totalExpected = payrolls.fold(
                    0.0, (sum, p) => sum + p.netSalary.toDouble());

                final employeeCount =
                    payrolls.map((p) => p.userId).toSet().length;

                return SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'ملخص رواتب ${_selectedMonth.month}/${_selectedMonth.year}',
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),
                      _buildSummaryGrid(
                          totalPaid, totalExpected, employeeCount),
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
                      _buildPayrollDataTable(payrolls),
                    ],
                  ),
                );
              },
            ),
    );
  }

  Widget _buildSummaryGrid(
      double totalPaid, double totalExpected, int employeeCount) {
    return GridView.count(
      crossAxisCount: 4,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 8,
      mainAxisSpacing: 5,
      childAspectRatio: 2, // 👈 يخلي الكروت أصغر

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
      ],
    );
  }

  Widget _buildSummaryCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Card(
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
                Text(title),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
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
    return DropdownButtonFormField<String>(
      value: _filterStatus,
      items: const [
        DropdownMenuItem(value: 'All', child: Text('الكل')),
        DropdownMenuItem(value: 'draft', child: Text('مسودة')),
        DropdownMenuItem(value: 'approved', child: Text('معتمد')),
        DropdownMenuItem(value: 'paid', child: Text('مدفوع')),
      ],
      onChanged: (value) {
        if (value != null) setState(() => _filterStatus = value);
      },
    );
  }

  Widget _buildPayrollDataTable(List<PayrollEntity> payrolls) {
    return DataTable(
      columns: const [
        DataColumn(label: Text('اسم الموظف')),
        DataColumn(label: Text('صافي الراتب'), numeric: true),
        DataColumn(label: Text('الحالة')),
      ],
      rows: payrolls.map((p) {
        return DataRow(
          cells: [
            DataCell(Text(p.userName)),
            DataCell(Text('${p.netSalary} EGP')),
            DataCell(_buildStatusChip(p.status)),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildStatusChip(String status) {
    Color color;
    String label;
    switch (status) {
      case 'paid':
        color = successColor;
        label = 'مدفوع';
        break;
      case 'approved':
        color = infoColor;
        label = 'معتمد';
        break;
      case 'draft':
        color = Colors.grey.shade600;
        label = 'مسودة';
        break;
      default:
        color = Colors.black;
        label = 'غير معروف';
    }
    return Chip(
      label: Text(label, style: const TextStyle(color: Colors.white)),
      backgroundColor: color,
    );
  }
}
