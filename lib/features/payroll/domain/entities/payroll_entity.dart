import 'package:equatable/equatable.dart';

enum PayrollStatus {
  draft,
  approved,
  paid,
  cancelled,
}

class PayrollEntity extends Equatable {
  final String id;
  final String userId;
  final String userName;
  final String period; // e.g., "2024-01"
  final double basicSalary;
  final double allowances;
  final double deductions;
  final double overtime;
  final double bonus;
  final double netSalary;
  final int workingDays;
  final int actualWorkingDays;
  final PayrollStatus status;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;

  const PayrollEntity({
    required this.id,
    required this.userId,
    required this.userName,
    required this.period,
    required this.basicSalary,
    required this.allowances,
    required this.deductions,
    required this.overtime,
    required this.bonus,
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
        userId,
        userName,
        period,
        basicSalary,
        allowances,
        deductions,
        overtime,
        bonus,
        netSalary,
        workingDays,
        actualWorkingDays,
        status,
        notes,
        createdAt,
        updatedAt,
      ];
}

