import 'package:dartz/dartz.dart';
import 'package:manzoma/features/payroll/domain/entities/payroll_rules_entity.dart';

import '../../../../core/error/failures.dart';

abstract class EmployeeRulesRepository {
  Future<Either<Failure, List<PayrollRuleEntity>>> assignRuleToEmployee(
      {required String userId, required String ruleId});
  Future<Either<Failure, PayrollRuleEntity>> createRule(PayrollRuleEntity rule);
  // ... other methods for update, delete etc.
}
