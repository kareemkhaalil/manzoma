import 'package:cloud_firestore/cloud_firestore.dart';

class AttendanceRecordModel {
  final String? id;
  final String branchId;
  final String branchName;
  final Timestamp checkInTime;
  final Timestamp? checkOutTime; // تغيير لجعل checkOutTime غير مطلوب

  final String employeeId;
  final String employeeName;
  final GeoPoint location;
  final String mobileIp;

  AttendanceRecordModel({
    this.id,
    required this.branchId,
    required this.branchName,
    required this.checkInTime,
    this.checkOutTime, // تغيير لجعل checkOutTime غير مطلوب
    required this.employeeId,
    required this.employeeName,
    required this.location,
    required this.mobileIp,
  });
  factory AttendanceRecordModel.fromJson(Map<String, dynamic> json) {
    return AttendanceRecordModel(
      id: json['id'],
      branchId: json['branchId'],
      branchName: json['branchName'],
      checkInTime: json['checkInTime'] as Timestamp,
      checkOutTime: json['checkOutTime'] as Timestamp?,
      employeeId: json['employeeId'],
      employeeName: json['employeeName'],
      location: json['location'] as GeoPoint,
      mobileIp: json['mobileIp'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'branchId': branchId,
      'branchName': branchName,
      'checkInTime': checkInTime,
      'checkOutTime': checkOutTime,
      'employeeId': employeeId,
      'employeeName': employeeName,
      'location': location,
      'mobileIp': mobileIp,
    };
  }

  AttendanceRecordModel copyWith({String? id}) {
    return AttendanceRecordModel(
      id: id ?? this.id,
      branchId: branchId,
      branchName: branchName,
      checkInTime: checkInTime,
      checkOutTime: checkOutTime, // تغيير لجعل checkOutTime غير مطلوب
      employeeId: employeeId,
      employeeName: employeeName,
      location: location,
      mobileIp: mobileIp,
    );
  }
}
