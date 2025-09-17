import 'package:manzoma/features/payroll/domain/entities/payroll_entity.dart';

class PayrollModel extends PayrollEntity {
  const PayrollModel({
    required super.id,
    required super.tenantId,
    required super.userId,
    required super.userName,
    required super.period,
    required super.periodStart,
    required super.periodEnd,
    required super.basicSalary,
    required super.gross,
    required super.netSalary,
    required super.workingDays,
    required super.actualWorkingDays,
    required super.status,
    super.notes,
    required super.createdAt,
    required super.updatedAt,
  });

  factory PayrollModel.fromJson(Map<String, dynamic> json) {
    return PayrollModel(
      id: json['id'] as String,
      tenantId: json['tenant_id'] as String,
      userId: json['user_id'] as String,
      userName: json['user_name'] as String,
      period: json['period'] as String,
      periodStart: DateTime.parse(json['period_start']),
      periodEnd: DateTime.parse(json['period_end']),
      basicSalary: (json['basic_salary'] as num).toDouble(),
      gross: (json['gross'] as num).toDouble(),
      netSalary: (json['net_salary'] as num).toDouble(),
      workingDays: json['working_days'] as int,
      actualWorkingDays: json['actual_working_days'] as int,
      status: json['status'] as String,
      notes: json['notes'] as String?,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tenant_id': tenantId,
      'user_id': userId,
      'user_name': userName,
      'period': period,
      'period_start': periodStart.toIso8601String(),
      'period_end': periodEnd.toIso8601String(),
      'basic_salary': basicSalary,
      'gross': gross,
      'net_salary': netSalary,
      'working_days': workingDays,
      'actual_working_days': actualWorkingDays,
      'status': status,
      'notes': notes,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  // from entity
  factory PayrollModel.fromEntity(PayrollEntity entity) {
    return PayrollModel(
      id: entity.id,
      tenantId: entity.tenantId,
      userId: entity.userId,
      userName: entity.userName,
      period: entity.period,
      periodStart: entity.periodStart,
      periodEnd: entity.periodEnd,
      basicSalary: entity.basicSalary,
      gross: entity.gross,
      netSalary: entity.netSalary,
      workingDays: entity.workingDays,
      actualWorkingDays: entity.actualWorkingDays,
      status: entity.status,
      notes: entity.notes,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }
}
