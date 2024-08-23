import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'dart:html' as html;

import 'package:bashkatep/core/models/branches_model.dart';
import 'package:bashkatep/core/models/attendance_model.dart';
import 'package:bashkatep/core/models/client_model.dart';
import 'package:bashkatep/core/models/userReportModel.dart';
import 'package:bashkatep/core/models/user_model.dart';

part 'attendance_state.dart';

class AttendanceCubit extends Cubit<AttendanceState> {
  AttendanceCubit() : super(AttendanceInitial());

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<ClientModel?> fetchClientData(String clientId) async {
    try {
      emit(AttendanceLoading());

      DocumentSnapshot clientSnapshot =
          await _firestore.collection('clients').doc(clientId).get();

      if (!clientSnapshot.exists) {
        throw Exception('Client not found.');
      }

      var clientData = clientSnapshot.data() as Map<String, dynamic>;
      ClientModel clientModel = ClientModel.fromJson(clientData, clientId);

      emit(AttendanceClientDataLoaded(clientModel));
      return clientModel;
    } catch (e) {
      emit(AttendanceFailure(e.toString()));
      debugPrint('Error fetching client data: $e');
      return null;
    }
  }

  Future<List<BranchModel>> fetchBranches(String clientId) async {
    try {
      DocumentSnapshot clientSnapshot =
          await _firestore.collection('clients').doc(clientId).get();

      if (!clientSnapshot.exists) {
        throw Exception('Client not found.');
      }

      List<BranchModel> branches = [];
      var clientData = clientSnapshot.data() as Map<String, dynamic>;
      if (clientData.containsKey('branches')) {
        for (var branchData in clientData['branches']) {
          branches.add(BranchModel.fromJson(
              branchData as Map<String, dynamic>, branchData['id']));
        }
      }
      return branches;
    } catch (e) {
      debugPrint('Error fetching branches for client $clientId: $e');
      throw Exception('Error fetching branches for client $clientId: $e');
    }
  }

  Future<List<UserModel>> fetchUsers(String clientId) async {
    try {
      DocumentSnapshot clientSnapshot =
          await _firestore.collection('clients').doc(clientId).get();

      if (!clientSnapshot.exists) {
        throw Exception('Client not found.');
      }

      List<UserModel> users = [];
      var clientData = clientSnapshot.data() as Map<String, dynamic>;
      if (clientData.containsKey('users')) {
        for (var usersData in clientData['users']) {
          users.add(UserModel.fromJson(
              usersData as Map<String, dynamic>, usersData['employee_id']));
        }
      }
      return users;
    } catch (e) {
      debugPrint('Error fetching branches for client $clientId: $e');
      throw Exception('Error fetching branches for client $clientId: $e');
    }
  }

  Future<List<AttendanceRecordModel>> fetchBranchAttendanceDataForToday(
      String clientId, String branchId) async {
    try {
      emit(AttendanceLoading());

      // Get the start and end of today
      DateTime now = DateTime.now();
      DateTime startOfDay = DateTime(now.year, now.month, now.day);
      DateTime endOfDay = startOfDay.add(Duration(days: 1));

      DocumentSnapshot clientSnapshot =
          await _firestore.collection('clients').doc(clientId).get();

      if (!clientSnapshot.exists) {
        throw Exception('Client not found.');
      }

      List<AttendanceRecordModel> branchAttendanceData = [];
      var clientData = clientSnapshot.data() as Map<String, dynamic>;
      if (clientData.containsKey('attendanceRecords')) {
        for (var record in clientData['attendanceRecords']) {
          AttendanceRecordModel attendanceRecord =
              AttendanceRecordModel.fromJson(record as Map<String, dynamic>);
          if (attendanceRecord.branchId == branchId &&
              attendanceRecord.checkInTime.toDate().isAfter(startOfDay) &&
              attendanceRecord.checkInTime.toDate().isBefore(endOfDay)) {
            branchAttendanceData.add(attendanceRecord);
          }
        }
      }

      List<Map<String, dynamic>> branchAttendanceDataJson =
          branchAttendanceData.map((record) => record.toJson()).toList();

      emit(AttendanceSuccess('', branchAttendanceDataJson));
      return branchAttendanceData;
    } catch (e) {
      emit(AttendanceFailure(e.toString()));
      debugPrint('Error fetching branch attendance data: $e');
      return [];
    }
  }

  Future<void> fetchUserReportsForToday(String clientId) async {
    try {
      emit(AttendanceLoading());
      DateTime now = DateTime.now();
      DateTime eightHoursAgo = now.subtract(Duration(hours: 8));

      QuerySnapshot userSnapshot = await _firestore
          .collection('clients')
          .doc(clientId)
          .collection('users')
          .get();

      List<UserReportModel> userReports = [];

      for (var userDoc in userSnapshot.docs) {
        String userId = userDoc.id;
        var userData = userDoc.data() as Map<String, dynamic>;

        print('Processing user: $userData');

        QuerySnapshot attendanceSnapshot = await _firestore
            .collection('clients')
            .doc(clientId)
            .collection('attendanceRecords')
            .where('employeeId', isEqualTo: userId)
            .where('checkInTime',
                isGreaterThanOrEqualTo: Timestamp.fromDate(eightHoursAgo))
            .where('checkInTime', isLessThanOrEqualTo: Timestamp.fromDate(now))
            .get();

        AttendanceRecordModel? attendanceRecord;
        if (attendanceSnapshot.docs.isNotEmpty) {
          print('Attendance records found: ${attendanceSnapshot.docs.length}');
          attendanceRecord = AttendanceRecordModel.fromJson(
              attendanceSnapshot.docs.first.data() as Map<String, dynamic>);
        } else {
          print('No attendance records found for user: $userId');
        }

        userReports.add(UserReportModel(
          employeeId: userId,
          name: userData['name'],
          loginDate: attendanceRecord?.checkInTime.toDate(),
          logoutDate: attendanceRecord?.checkOutTime?.toDate(),
          attendanceStatus: attendanceRecord != null ? 'حاضر' : 'غائب',
        ));
      }

      emit(UserReportsLoaded(userReports));
    } catch (e) {
      emit(AttendanceFailure(e.toString()));
      print('Error fetching user reports: $e');
    }
  }

  Future<void> fetchUserAttendanceDetails(
      String clientId, String userId) async {
    try {
      emit(AttendanceLoading());

      // Fetch user data
      DocumentSnapshot userSnapshot = await _firestore
          .collection('clients')
          .doc(clientId)
          .collection('users')
          .doc(userId)
          .get();

      if (!userSnapshot.exists) {
        throw Exception('User not found.');
      }

      var userData = userSnapshot.data() as Map<String, dynamic>;
      String userName = userData['name'];

      // Fetch attendance records
      QuerySnapshot attendanceSnapshot = await _firestore
          .collection('clients')
          .doc(clientId)
          .collection('attendanceRecords')
          .where('employeeId', isEqualTo: userId)
          .get();

      List<AttendanceDetails> attendanceDetails =
          attendanceSnapshot.docs.map((doc) {
        var data = doc.data() as Map<String, dynamic>;
        return AttendanceDetails(
          checkInTime: (data['checkInTime'] as Timestamp).toDate(),
          checkOutTime: data['checkOutTime'] != null
              ? (data['checkOutTime'] as Timestamp).toDate()
              : null,
        );
      }).toList();

      emit(UserAttendanceDetailsLoaded(attendanceDetails, userName));
    } catch (e) {
      emit(AttendanceFailure(e.toString()));
      debugPrint('Error fetching user attendance details: $e');
    }
  }

  Future<void> fetchFilteredAttendanceData(
      DateTime selectedDate, String branchId, clientId) async {
    try {
      emit(AttendanceLoading());

      // Get the start and end of the selected date
      DateTime startOfDay =
          DateTime(selectedDate.year, selectedDate.month, selectedDate.day);
      DateTime endOfDay = startOfDay.add(Duration(days: 1));

      // Fetch the client document
      DocumentSnapshot clientSnapshot =
          await _firestore.collection('clients').doc(clientId).get();

      if (!clientSnapshot.exists) {
        throw Exception('Client not found.');
      }

      List<Map<String, dynamic>> filteredAttendanceData = [];
      var clientData = clientSnapshot.data() as Map<String, dynamic>;

      if (clientData.containsKey('attendanceRecords')) {
        for (var record in clientData['attendanceRecords']) {
          AttendanceRecordModel attendanceRecord =
              AttendanceRecordModel.fromJson(record as Map<String, dynamic>);

          if (attendanceRecord.branchId == branchId &&
              attendanceRecord.checkInTime.toDate().isAfter(startOfDay) &&
              attendanceRecord.checkInTime.toDate().isBefore(endOfDay)) {
            filteredAttendanceData.add(attendanceRecord.toJson());
          }
        }
      }

      emit(AttendanceFilteredSuccess(filteredAttendanceData));
    } catch (e) {
      emit(AttendanceFailure(e.toString()));
      debugPrint('Error fetching filtered attendance data: $e');
    }
  }

  Future<void> exportAttendance(BuildContext context, String clientId) async {
    try {
      emit(AttendanceLoading());

      String outputFileName = 'Attendance.xlsx';
      List<Map<String, dynamic>> attendanceData =
          await fetchAttendanceData(clientId);

      String filePath = await generateAttendanceExcel(outputFileName, clientId);
      debugPrint(filePath);

      emit(AttendanceExportSuccess(filePath));
      emit(AttendanceLoading());

      // العودة إلى الحالة الأولية بعد فترة قصيرة
      await fetchClientData(clientId);
    } catch (e) {
      emit(AttendanceExportFailure(e.toString()));
      debugPrint(e.toString());
    }
  }

  Future<List<Map<String, dynamic>>> fetchAttendanceData(
      String clientId) async {
    QuerySnapshot querySnapshot = await _firestore
        .collection('clients')
        .doc(clientId)
        .collection('attendanceRecords')
        .get();

    List<Map<String, dynamic>> attendanceData = querySnapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();

    return attendanceData;
  }

  Future<String> generateAttendanceExcel(
      String outputFileName, clientId) async {
    var excel = Excel.createExcel();
    Sheet sheetObject = excel['الحضور'];

    // Append header row with the new column for hours worked
    sheetObject.appendRow([
      const TextCellValue('كود الفرع'),
      const TextCellValue('اسم الفرع'),
      const TextCellValue('تاريخ الحضور'),
      const TextCellValue('تاريخ الانصراف'),
      const TextCellValue('كود المستخدم'),
      const TextCellValue('اسم المستخدم'),
      const TextCellValue('العنوان'),
      const TextCellValue('عدد الساعات') // New column for hours worked
    ]);

    List<Map<String, dynamic>> attendanceData =
        await fetchAttendanceData(clientId);

    for (var data in attendanceData) {
      String locationString = data['location'] != null
          ? '${data['location'].latitude}, ${data['location'].longitude}'
          : 'غير متوفر';

      DateTime? checkInTime = (data['checkInTime'] as Timestamp?)?.toDate();
      DateTime? checkOutTime = (data['checkOutTime'] as Timestamp?)?.toDate();

      String hoursWorked = 'غير متوفر';
      if (checkInTime != null && checkOutTime != null) {
        Duration duration = checkOutTime.difference(checkInTime);
        hoursWorked =
            (duration.inHours + duration.inMinutes / 60).toStringAsFixed(2) +
                ' ساعة';
      }

      sheetObject.appendRow([
        TextCellValue(data['branchId']?.toString() ?? 'غير متوفر'),
        TextCellValue(data['branchName'] ?? 'غير متوفر'),
        TextCellValue(checkInTime?.toString() ?? 'غير متوفر'),
        TextCellValue(checkOutTime?.toString() ?? 'غير متوفر'),
        TextCellValue(data['employeeId']?.toString() ?? 'غير متوفر'),
        TextCellValue(data['employeeName'] ?? 'غير متوفر'),
        TextCellValue(locationString),
        TextCellValue(hoursWorked) // New column data
      ]);
    }

    List<int>? fileBytes = excel.encode();

    if (fileBytes != null) {
      final blob = html.Blob([fileBytes]);
      final url = html.Url.createObjectUrlFromBlob(blob);
      final anchor = html.AnchorElement(href: url)
        ..setAttribute("download", outputFileName)
        ..click();
      html.Url.revokeObjectUrl(url);
    } else {
      throw Exception("Error encoding Excel file.");
    }

    return outputFileName;
  }

  Future<List<Map<String, dynamic>>> fetchBranchAttendanceData(
      String branchId, clientId) async {
    try {
      emit(AttendanceLoading());
      QuerySnapshot querySnapshot = await _firestore
          .collection('clients')
          .doc(clientId)
          .collection('attendanceRecords')
          .where('branchId', isEqualTo: branchId)
          .get();

      List<Map<String, dynamic>> branchAttendanceData = querySnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();

      emit(AttendanceSuccess('', branchAttendanceData));
      return branchAttendanceData;
    } catch (e) {
      emit(AttendanceFailure(e.toString()));
      debugPrint('Error fetching branch attendance data: $e');
      return [];
    }
  }

  Future<void> fetchFilteredBranchAttendanceData(
      String branchId, clientId, DateTime startDate, DateTime endDate) async {
    try {
      emit(AttendanceLoading());
      debugPrint(
          'Filtering attendance data for branchId: $branchId from $startDate to $endDate');
      QuerySnapshot querySnapshot = await _firestore
          .collection('clients')
          .doc(clientId)
          .collection('attendanceRecords')
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
