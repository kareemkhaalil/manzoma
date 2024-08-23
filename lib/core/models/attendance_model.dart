import 'package:cloud_firestore/cloud_firestore.dart';

class AttendanceRecordModel {
  final String? id;
  final String branchId;
  final String branchName;
  final Timestamp checkInTime;
  final Timestamp? checkOutTime;
  final String? sessionId;
  final String employeeId;
  final String employeeName;
  final GeoPoint location;
  final String mobileIp;

  AttendanceRecordModel({
    this.id,
    required this.branchId,
    required this.branchName,
    required this.checkInTime,
    this.checkOutTime,
    required this.employeeId,
    required this.employeeName,
    required this.location,
    required this.mobileIp,
    this.sessionId,
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
      sessionId: json['sessionId'],
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
      'sessionId': sessionId,
    };
  }

  AttendanceRecordModel copyWith({
    String? id,
    Timestamp? checkOutTime,
  }) {
    return AttendanceRecordModel(
      id: id ?? this.id,
      branchId: branchId,
      branchName: branchName,
      checkInTime: checkInTime,
      checkOutTime: checkOutTime ?? this.checkOutTime,
      employeeId: employeeId,
      employeeName: employeeName,
      location: location,
      mobileIp: mobileIp,
      sessionId: sessionId,
    );
  }
}
