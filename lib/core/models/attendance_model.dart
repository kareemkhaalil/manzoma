import 'package:cloud_firestore/cloud_firestore.dart';

class AttendanceRecordModel {
  final String branchId;
  final String branchName;
  final Timestamp checkInTime;
  final String employeeId;
  final String employeeName;
  final GeoPoint location;
  final String mobileIp;
  Timestamp?
      checkOutTime; // يمكن أن يكون checkOutTime فارغاً إذا لم يتم تسجيل الخروج بعد

  AttendanceRecordModel({
    required this.branchId,
    required this.branchName,
    required this.checkInTime,
    required this.employeeId,
    required this.employeeName,
    required this.location,
    required this.mobileIp,
    this.checkOutTime,
  });

  // إضافة طريقة toJson لتحويل الكائن إلى JSON
  Map<String, dynamic> toJson() {
    return {
      'branchId': branchId,
      'branchName': branchName,
      'checkInTime': checkInTime,
      'employeeId': employeeId,
      'employeeName': employeeName,
      'location': location,
      'mobileIp': mobileIp,
      'checkOutTime': checkOutTime,
    };
  }

  // إضافة طريقة fromJson لتحويل JSON إلى كائن
  factory AttendanceRecordModel.fromJson(Map<String, dynamic> json) {
    return AttendanceRecordModel(
      branchId: json['branchId'],
      branchName: json['branchName'],
      checkInTime: json['checkInTime'],
      employeeId: json['employeeId'],
      employeeName: json['employeeName'],
      location: json['location'],
      mobileIp: json['mobileIp'],
      checkOutTime: json['checkOutTime'],
    );
  }
}
