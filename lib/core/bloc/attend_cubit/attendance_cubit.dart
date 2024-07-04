import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'dart:html' as html;

import 'package:hudor/core/models/branches_model.dart'; // Replace with your branch model
part 'attendance_state.dart'; // Import your state file

class AttendanceCubit extends Cubit<AttendanceState> {
  AttendanceCubit() : super(AttendanceInitial());

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<BranchModel>> fetchBranches() async {
    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('branch').get();
      List<BranchModel> branches = snapshot.docs.map((doc) {
        return BranchModel.fromJson(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
      return branches;
    } catch (e) {
      debugPrint('Error fetching branches: $e');
      throw Exception('Error fetching branches: $e');
    }
  }

  Future<void> fetchFilteredAttendanceData(
      DateTime selectedDate, String branchId) async {
    try {
      emit(AttendanceLoading());
      QuerySnapshot querySnapshot = await _firestore
          .collection('attendance')
          .where('checkInTime',
              isGreaterThanOrEqualTo: Timestamp.fromDate(selectedDate))
          .where('branchId', isEqualTo: branchId)
          .get();

      List<Map<String, dynamic>> filteredAttendanceData = [];

      for (var doc in querySnapshot.docs) {
        filteredAttendanceData.add(doc.data() as Map<String, dynamic>);
      }

      emit(AttendanceFilteredSuccess(filteredAttendanceData));
    } catch (e) {
      emit(AttendanceFailure(e.toString()));
      debugPrint('Error fetching filtered attendance data: $e');
    }
  }

  Future<void> exportAttendance(BuildContext context) async {
    try {
      emit(AttendanceLoading());

      String outputFileName =
          'حضور فولت.xlsx'; // Replace with your desired file name
      List<Map<String, dynamic>> attendanceData = await fetchAttendanceData();

      String filePath = await generateAttendanceExcel(outputFileName);
      debugPrint(filePath);

      emit(AttendanceSuccess(
          filePath, attendanceData)); // تمرير المعطيات المطلوبة
    } catch (e) {
      emit(AttendanceFailure(e.toString()));
      debugPrint(e.toString());
    }
  }

  Future<List<Map<String, dynamic>>> fetchAttendanceData() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('attendance').get();

    List<Map<String, dynamic>> attendanceData = [];

    for (var doc in querySnapshot.docs) {
      attendanceData.add(doc.data() as Map<String, dynamic>);
    }

    return attendanceData;
  }

  Future<String> generateAttendanceExcel(String outputFileName) async {
    var excel = Excel.createExcel();
    Sheet sheetObject = excel['الحضور']; // Replace with your sheet name

    sheetObject.appendRow([
      const TextCellValue('كود الفرع'),
      const TextCellValue('اسم الفرع'),
      const TextCellValue('تاريخ الحضور'),
      const TextCellValue('تاريخ الانصراف'),
      const TextCellValue('كود المستخدم'),
      const TextCellValue('اسم المستخدم'),
      const TextCellValue('العنوان'),
      const TextCellValue('Mobile IP')
    ]);

    List<Map<String, dynamic>> attendanceData = await fetchAttendanceData();

    for (var data in attendanceData) {
      String locationString = data['location'] != null
          ? '${data['location'].latitude}, ${data['location'].longitude}'
          : 'غير متوفر';

      sheetObject.appendRow([
        TextCellValue(data['branchId']?.toString() ?? 'غير متوفر'),
        TextCellValue(data['branchName'] ?? 'غير متوفر'),
        TextCellValue(
            (data['checkInTime'] as Timestamp?)?.toDate().toString() ??
                'غير متوفر'),
        TextCellValue(
            (data['checkOutTime'] as Timestamp?)?.toDate().toString() ??
                'غير متوفر'),
        TextCellValue(data['employeeId']?.toString() ?? 'غير متوفر'),
        TextCellValue(data['employeeName'] ?? 'غير متوفر'),
        TextCellValue(locationString),
        TextCellValue(data['mobileIp'] ?? 'غير متوفر'),
      ]);
    }

    List<int>? fileBytes = excel.encode();

    if (fileBytes != null) {
      // Convert bytes to Blob
      final blob = html.Blob([fileBytes]);
      // Create download link
      final url = html.Url.createObjectUrlFromBlob(blob);
      final anchor = html.AnchorElement(href: url)
        ..setAttribute("download", outputFileName)
        ..click();
      // Revoke the download link after download
      html.Url.revokeObjectUrl(url);
    } else {
      throw Exception("Error encoding Excel file.");
    }

    return outputFileName;
  }

  Future<List<Map<String, dynamic>>> fetchBranchAttendanceData(
      String branchId) async {
    try {
      emit(AttendanceLoading());
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('attendance')
          .where('branchId', isEqualTo: branchId)
          .get();

      List<Map<String, dynamic>> branchAttendanceData = [];

      for (var doc in querySnapshot.docs) {
        branchAttendanceData.add(doc.data() as Map<String, dynamic>);
      }

      emit(AttendanceSuccess('', branchAttendanceData));
      return branchAttendanceData;
    } catch (e) {
      emit(AttendanceFailure(e.toString()));
      debugPrint('Error fetching branch attendance data: $e');
      return [];
    }
  }

  Future<void> fetchFilteredBranchAttendanceData(
      String branchId, DateTime startDate, DateTime endDate) async {
    try {
      emit(AttendanceLoading());
      debugPrint(
          'Filtering attendance data for branchId: $branchId from $startDate to $endDate');
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('attendance')
          .where('branchId', isEqualTo: branchId)
          .where('checkInTime',
              isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))
          .where('checkInTime',
              isLessThanOrEqualTo: Timestamp.fromDate(endDate))
          .get();

      List<Map<String, dynamic>> branchAttendanceData = querySnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();

      debugPrint('Filtered data count: ${branchAttendanceData.length}');
      emit(AttendanceSuccess('', branchAttendanceData));
    } catch (e) {
      emit(AttendanceFailure(e.toString()));
      debugPrint('Error fetching filtered branch attendance data: $e');
    }
  }
}
