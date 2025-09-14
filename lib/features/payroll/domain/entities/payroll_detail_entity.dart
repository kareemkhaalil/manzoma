import 'package:equatable/equatable.dart';
import 'package:manzoma/features/payroll/domain/entities/payroll_rules_entity.dart';

class PayrollDetailEntity extends Equatable {
  final String id;
  final String payrollId;
  final String ruleName;
  final RuleType type;
  final double amount;

  const PayrollDetailEntity({
    required this.id,
    required this.payrollId,
    required this.ruleName,
    required this.type,
    required this.amount,
  });

  @override
  List<Object?> get props => [id, payrollId, ruleName, type, amount];
}
