import 'package:equatable/equatable.dart';

enum RuleType { allowance, deduction }

enum CalculationMethod { fixed, percentage, per_hour, custom }

class PayrollRuleEntity extends Equatable {
  final String id;
  final String name;
  final String? description;
  final RuleType type;
  final CalculationMethod calculationMethod;
  final double value;
  final bool isAutomatic;

  const PayrollRuleEntity({
    required this.id,
    required this.name,
    this.description,
    required this.type,
    required this.calculationMethod,
    required this.value,
    required this.isAutomatic,
  });

  @override
  List<Object?> get props =>
      [id, name, description, type, calculationMethod, value, isAutomatic];
}
