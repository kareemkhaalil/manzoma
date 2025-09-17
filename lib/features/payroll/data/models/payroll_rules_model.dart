import 'package:manzoma/features/payroll/domain/entities/payroll_rules_entity.dart';

class PayrollRuleModel extends PayrollRuleEntity {
  const PayrollRuleModel({
    required super.id,
    required super.tenantId,
    required super.name,
    super.description,
    required super.type,
    required super.calculationMethod,
    required super.value,
    required super.isAutomatic,
    required super.createdAt,
    required super.updatedAt,
  });

  factory PayrollRuleModel.fromJson(Map<String, dynamic> json) {
    return PayrollRuleModel(
      id: json['id'] as String,
      tenantId: json['tenant_id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      type: json['type'] as String,
      calculationMethod: json['calculation_method'] as String,
      value: (json['value'] as num).toDouble(),
      isAutomatic: json['is_automatic'] as bool,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tenant_id': tenantId,
      'name': name,
      'description': description,
      'type': type,
      'calculation_method': calculationMethod,
      'value': value,
      'is_automatic': isAutomatic,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
