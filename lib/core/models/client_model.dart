import 'package:bashkatep/core/models/attendance_model.dart';
import 'package:bashkatep/core/models/branches_model.dart';
import 'package:bashkatep/core/models/user_model.dart';

class ClientModel {
  final String clientId;
  String clientName;
  List<UserModel> admins;
  List<UserModel> users;
  List<BranchModel> branches;
  List<AttendanceRecordModel> attendanceRecords;
  int maxAdmins;
  int maxUsers;
  int maxBranches;
  double userCost;
  double adminCost;
  double branchCost;
  bool isSuspended;

  ClientModel({
    required this.clientId,
    required this.clientName,
    required this.admins,
    required this.users,
    required this.branches,
    required this.attendanceRecords,
    required this.maxAdmins,
    required this.maxUsers,
    required this.maxBranches,
    required this.userCost,
    required this.adminCost,
    required this.branchCost,
    required this.isSuspended,
  });
  factory ClientModel.fromJson(Map<String, dynamic> json, String id) {
    return ClientModel(
      clientId: id,
      clientName: json['clientName'] ?? '',
      admins: (json['admins'] as List<dynamic>?)
              ?.map((e) => UserModel.fromJson(
                  e as Map<String, dynamic>, e['employee_id'] ?? ''))
              .toList() ??
          [],
      users: (json['users'] as List<dynamic>?)
              ?.map((e) => UserModel.fromJson(
                  e as Map<String, dynamic>, e['employee_id'] ?? ''))
              .toList() ??
          [],
      branches: (json['branches'] as List<dynamic>?)
              ?.map((e) => BranchModel.fromJson(
                  e as Map<String, dynamic>, e['id'] ?? ''))
              .toList() ??
          [],
      attendanceRecords: (json['attendanceRecords'] as List<dynamic>?)
              ?.map((e) =>
                  AttendanceRecordModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      maxAdmins: json['maxAdmins'] ?? 5,
      maxUsers: json['maxUsers'] ?? 20,
      maxBranches: json['maxBranches'] ?? 10,
      userCost: (json['userCost'] as num?)?.toDouble() ?? 0.0,
      adminCost: (json['adminCost'] as num?)?.toDouble() ?? 0.0,
      branchCost: (json['branchCost'] as num?)?.toDouble() ?? 0.0,
      isSuspended: json['isSuspended'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'clientName': clientName,
      'admins': admins.map((e) => e.toJson()).toList(),
      'users': users.map((e) => e.toJson()).toList(),
      'branches': branches.map((e) => e.toJson()).toList(),
      'attendanceRecords': attendanceRecords.map((e) => e.toJson()).toList(),
      'maxAdmins': maxAdmins,
      'maxUsers': maxUsers,
      'maxBranches': maxBranches,
      'userCost': userCost,
      'adminCost': adminCost,
      'branchCost': branchCost,
      'isSuspended': isSuspended,
    };
  }

  ClientModel copyWith({
    String? clientId,
    String? clientName,
    List<UserModel>? admins,
    List<UserModel>? users,
    List<BranchModel>? branches,
    List<AttendanceRecordModel>? attendanceRecords,
    int? maxAdmins,
    int? maxUsers,
    int? maxBranches,
    double? userCost,
    double? adminCost,
    double? branchCost,
    bool? isSuspended,
  }) {
    return ClientModel(
      clientId: clientId ?? this.clientId,
      clientName: clientName ?? this.clientName,
      admins: admins ?? this.admins,
      users: users ?? this.users,
      branches: branches ?? this.branches,
      attendanceRecords: attendanceRecords ?? this.attendanceRecords,
      maxAdmins: maxAdmins ?? this.maxAdmins,
      maxUsers: maxUsers ?? this.maxUsers,
      maxBranches: maxBranches ?? this.maxBranches,
      userCost: userCost ?? this.userCost,
      adminCost: adminCost ?? this.adminCost,
      branchCost: branchCost ?? this.branchCost,
      isSuspended: isSuspended ?? this.isSuspended,
    );
  }
}
