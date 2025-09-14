import 'package:manzoma/features/payroll/domain/entities/payroll_rules_entity.dart';

import '../../domain/entities/payroll_detail_entity.dart';

class PayrollDetailModel extends PayrollDetailEntity {
  const PayrollDetailModel({
    required super.id,
    required super.payrollId,
    required super.ruleName,
    required super.type,
    required super.amount,
  });

  factory PayrollDetailModel.fromJson(Map<String, dynamic> json) {
    return PayrollDetailModel(
      id: json['id'] as String,
      payrollId: json['payroll_id'] as String,
      ruleName: json['rule_name'] as String,
      type: (json['type'] as String) == 'allowance'
          ? RuleType.allowance
          : RuleType.deduction,
      amount: (json['amount'] as num).toDouble(),
    );
  }
}
