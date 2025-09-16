import 'package:equatable/equatable.dart';

class PayrollRuleEntity extends Equatable {
  final String id;
  final String tenantId;
  final String name;
  final String? description;
  final String type; // allowance | deduction
  final String calculationMethod; // fixed | percentage | per_hour | custom
  final double value;
  final bool isAutomatic;
  final DateTime createdAt;
  final DateTime updatedAt;

  const PayrollRuleEntity({
    required this.id,
    required this.tenantId,
    required this.name,
    this.description,
    required this.type,
    required this.calculationMethod,
    required this.value,
    required this.isAutomatic,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        tenantId,
        name,
        description,
        type,
        calculationMethod,
        value,
        isAutomatic,
        createdAt,
        updatedAt,
      ];
}
