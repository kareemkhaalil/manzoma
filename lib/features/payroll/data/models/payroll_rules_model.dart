import 'package:manzoma/features/payroll/domain/entities/payroll_rules_entity.dart';

class PayrollRuleModel extends PayrollRuleEntity {
  const PayrollRuleModel({
    required super.id,
    required super.name,
    super.description,
    required super.type,
    required super.calculationMethod,
    required super.value,
    required super.isAutomatic,
  });

  factory PayrollRuleModel.fromJson(Map<String, dynamic> json) {
    return PayrollRuleModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      type: (json['type'] as String) == 'allowance'
          ? RuleType.allowance
          : RuleType.deduction,
      calculationMethod: CalculationMethod.values.firstWhere(
        (e) => e.name == json['calculation_method'],
        orElse: () => CalculationMethod.fixed,
      ),
      value: (json['value'] as num).toDouble(),
      isAutomatic: json['is_automatic'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'type': type.name,
      'calculation_method': calculationMethod.name,
      'value': value,
      'is_automatic': isAutomatic,
    };
  }
}
