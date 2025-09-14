import 'package:dartz/dartz.dart';
import 'package:manzoma/features/payroll/domain/entities/payroll_rules_entity.dart';

import '../../../../core/error/failures.dart';

abstract class PayrollRulesRepository {
  Future<Either<Failure, List<PayrollRuleEntity>>> getAllRules();
  Future<Either<Failure, PayrollRuleEntity>> createRule(PayrollRuleEntity rule);
  Future<Either<Failure, PayrollRuleEntity>> updateRule({
    required String ruleId,
    required String name,
    String? description,
    required double value,
    required String type,
  });
  Future<Either<Failure, void>> deleteRule(String ruleId);
  // ... other methods for update, delete etc.
}
