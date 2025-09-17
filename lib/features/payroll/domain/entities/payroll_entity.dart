import 'package:equatable/equatable.dart';

class PayrollEntity extends Equatable {
  final String id;
  final String tenantId;
  final String userId;
  final String userName;
  final String period;
  final DateTime periodStart;
  final DateTime periodEnd;
  final double basicSalary;
  final double gross;
  final double netSalary;
  final int workingDays;
  final int actualWorkingDays;
  final String status;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;

  const PayrollEntity({
    required this.id,
    required this.tenantId,
    required this.userId,
    required this.userName,
    required this.period,
    required this.periodStart,
    required this.periodEnd,
    required this.basicSalary,
    required this.gross,
    required this.netSalary,
    required this.workingDays,
    required this.actualWorkingDays,
    required this.status,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        tenantId,
        userId,
        userName,
        period,
        periodStart,
        periodEnd,
        basicSalary,
        gross,
        netSalary,
        workingDays,
        actualWorkingDays,
        status,
        notes,
        createdAt,
        updatedAt,
      ];

  // to json

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tenantId': tenantId,
      'userId': userId,
      'userName': userName,
      'period': period,
      'periodStart': periodStart.toIso8601String(),
      'periodEnd': periodEnd.toIso8601String(),
      'basicSalary': basicSalary,
      'gross': gross,
      'netSalary': netSalary,
      'workingDays': workingDays,
      'actualWorkingDays': actualWorkingDays,
      'status': status,
      'notes': notes,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
