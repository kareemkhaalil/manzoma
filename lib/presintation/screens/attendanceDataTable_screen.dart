import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hudor/core/bloc/attend_cubit/attendance_cubit.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AttendanceDataTableScreen extends StatefulWidget {
  final String branchId;

  const AttendanceDataTableScreen({super.key, required this.branchId});

  @override
  _AttendanceDataTableScreenState createState() =>
      _AttendanceDataTableScreenState();
}

class _AttendanceDataTableScreenState extends State<AttendanceDataTableScreen> {
  late AttendanceCubit _attendanceCubit;
  DateTime now = DateTime.now();
  DateTime today =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  late DateTime _selectedDate = today; // التاريخ الافتراضي

  @override
  void initState() {
    super.initState();
    _attendanceCubit = AttendanceCubit();
    _attendanceCubit.fetchFilteredAttendanceData(
        _selectedDate, widget.branchId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('بيانات الحضور'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) =>
                    AttendanceDataTableFilterScreen(branchId: widget.branchId),
              ));
            },
          ),
        ],
      ),
      body: BlocProvider(
        create: (context) => _attendanceCubit,
        child: BlocBuilder<AttendanceCubit, AttendanceState>(
          builder: (context, state) {
            if (state is AttendanceLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is AttendanceSuccess) {
              if (state.attendanceData.isEmpty) {
                return const Center(child: Text('لا توجد بيانات.'));
              }
              return AttendanceDataTable(attendanceData: state.attendanceData);
            } else if (state is AttendanceFailure) {
              return Center(child: Text('خطأ: ${state.error}'));
            } else if (state is AttendanceFilteredSuccess) {
              if (state.filteredAttendanceData.isEmpty) {
                return const Center(
                    child: Text('لا توجد بيانات للتاريخ المحدد.'));
              }
              return Column(
                children: [
                  _buildDateSelector(),
                  Expanded(
                    child: AttendanceDataTable(
                        attendanceData: state.filteredAttendanceData),
                  ),
                ],
              );
            } else {
              return const Center(child: Text('لا توجد بيانات.'));
            }
          },
        ),
      ),
    );
  }

  Widget _buildDateSelector() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextButton(
            onPressed: () => _selectDate(context),
            child: const Text('اختر تاريخ'),
          ),
          Text('التاريخ المحدد: ${_selectedDate.toString().split(' ')[0]}'),
        ],
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _attendanceCubit.fetchFilteredAttendanceData(
            _selectedDate, widget.branchId);
      });
    }
  }

  @override
  void dispose() {
    _attendanceCubit.close();
    super.dispose();
  }
}

class AttendanceDataTableFilterScreen extends StatefulWidget {
  final String branchId;

  const AttendanceDataTableFilterScreen({super.key, required this.branchId});

  @override
  _AttendanceDataTableFilterScreenState createState() =>
      _AttendanceDataTableFilterScreenState();
}

class _AttendanceDataTableFilterScreenState
    extends State<AttendanceDataTableFilterScreen> {
  DateTime? startDate;
  DateTime? endDate;

  TextEditingController startDateController = TextEditingController();
  TextEditingController endDateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('تصفية بيانات الحضور'),
      ),
      body: BlocProvider(
        create: (context) =>
            AttendanceCubit()..fetchBranchAttendanceData(widget.branchId),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: startDateController,
                      decoration: const InputDecoration(
                        labelText: 'تاريخ البداية',
                        hintText: 'اختر تاريخ البداية',
                      ),
                      readOnly: true,
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2101),
                        );
                        if (pickedDate != null) {
                          setState(() {
                            startDate = pickedDate;
                            startDateController.text =
                                pickedDate.toLocal().toString().split(' ')[0];
                          });
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextField(
                      controller: endDateController,
                      decoration: const InputDecoration(
                        labelText: 'تاريخ النهاية',
                        hintText: 'اختر تاريخ النهاية',
                      ),
                      readOnly: true,
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2101),
                        );
                        if (pickedDate != null) {
                          setState(() {
                            endDate = pickedDate;
                            endDateController.text =
                                pickedDate.toLocal().toString().split(' ')[0];
                          });
                        }
                      },
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (startDate != null && endDate != null) {
                        BlocProvider.of<AttendanceCubit>(context)
                            .fetchFilteredBranchAttendanceData(
                          widget.branchId,
                          startDate!,
                          endDate!,
                        );
                      }
                    },
                    child: const Text('تصفية'),
                  ),
                ],
              ),
            ),
            Expanded(
              child: BlocBuilder<AttendanceCubit, AttendanceState>(
                builder: (context, state) {
                  if (state is AttendanceLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is AttendanceSuccess) {
                    if (state.attendanceData.isEmpty) {
                      return const Center(child: Text('لا توجد بيانات.'));
                    }
                    return AttendanceDataTable(
                        attendanceData: state.attendanceData);
                  } else if (state is AttendanceFailure) {
                    return Center(child: Text('خطأ: ${state.error}'));
                  } else {
                    return const Center(child: Text('لا توجد بيانات.'));
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AttendanceDataTable extends StatelessWidget {
  final List<Map<String, dynamic>> attendanceData;

  const AttendanceDataTable({super.key, required this.attendanceData});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: DataTable2(
        columnSpacing: 30,
        horizontalMargin: 12,
        minWidth: 600,
        columns: const [
          DataColumn2(
            label: Text('كود الفرع'),
            size: ColumnSize.L,
          ),
          DataColumn(
            label: Text('اسم الفرع'),
          ),
          DataColumn(
            label: Text('تاريخ الحضور'),
          ),
          DataColumn(
            label: Text('تاريخ الانصراف'),
          ),
          DataColumn(
            label: Text('كود المستخدم'),
          ),
          DataColumn(
            label: Text('اسم المستخدم'),
          ),
          DataColumn(
            label: Text('العنوان'),
          ),
          DataColumn(
            label: Text('Mobile IP'),
          ),
        ],
        rows: attendanceData
            .map((data) => DataRow(cells: [
                  DataCell(Text(data['branchId']?.toString() ?? 'غير متوفر')),
                  DataCell(Text(data['branchName'] ?? 'غير متوفر')),
                  DataCell(Text((data['checkInTime'] as Timestamp?)
                          ?.toDate()
                          .toString() ??
                      'غير متوفر')),
                  DataCell(Text((data['checkOutTime'] as Timestamp?)
                          ?.toDate()
                          .toString() ??
                      'غير متوفر')),
                  DataCell(Text(data['employeeId']?.toString() ?? 'غير متوفر')),
                  DataCell(Text(data['employeeName'] ?? 'غير متوفر')),
                  DataCell(Text(data['location'] != null
                      ? '${data['location'].latitude}, ${data['location'].longitude}'
                      : 'غير متوفر')),
                  DataCell(Text(data['mobileIP'] ?? 'غير متوفر')),
                ]))
            .toList(),
      ),
    );
  }
}
