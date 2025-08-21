import '../../domain/entities/payroll_entity.dart';

class PayrollModel extends PayrollEntity {
  const PayrollModel({
    required super.id,
    required super.userId,
    required super.userName,
    required super.period,
    required super.basicSalary,
    required super.allowances,
    required super.deductions,
    required super.overtime,
    required super.bonus,
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
      userId: json['user_id'] as String,
      userName: json['user_name'] as String,
      period: json['period'] as String,
      basicSalary: (json['basic_salary'] as num).toDouble(),
      allowances: (json['allowances'] as num).toDouble(),
      deductions: (json['deductions'] as num).toDouble(),
      overtime: (json['overtime'] as num).toDouble(),
      bonus: (json['bonus'] as num).toDouble(),
      netSalary: (json['net_salary'] as num).toDouble(),
      workingDays: json['working_days'] as int,
      actualWorkingDays: json['actual_working_days'] as int,
      status: PayrollStatus.values.firstWhere(
        (status) => status.name == json['status'],
        orElse: () => PayrollStatus.draft,
      ),
      notes: json['notes'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'user_name': userName,
      'period': period,
      'basic_salary': basicSalary,
      'allowances': allowances,
      'deductions': deductions,
      'overtime': overtime,
      'bonus': bonus,
      'net_salary': netSalary,
      'working_days': workingDays,
      'actual_working_days': actualWorkingDays,
      'status': status.name,
      'notes': notes,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  PayrollModel copyWith({
    String? id,
    String? userId,
    String? userName,
    String? period,
    double? basicSalary,
    double? allowances,
    double? deductions,
    double? overtime,
    double? bonus,
    double? netSalary,
    int? workingDays,
    int? actualWorkingDays,
    PayrollStatus? status,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return PayrollModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      period: period ?? this.period,
      basicSalary: basicSalary ?? this.basicSalary,
      allowances: allowances ?? this.allowances,
      deductions: deductions ?? this.deductions,
      overtime: overtime ?? this.overtime,
      bonus: bonus ?? this.bonus,
      netSalary: netSalary ?? this.netSalary,
      workingDays: workingDays ?? this.workingDays,
      actualWorkingDays: actualWorkingDays ?? this.actualWorkingDays,
      status: status ?? this.status,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

