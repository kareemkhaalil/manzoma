import 'package:dartz/dartz.dart';
import 'package:manzoma/features/payroll/domain/entities/payroll_rules_entity.dart';
import 'package:manzoma/features/payroll/domain/repositories/payroll_rules_repo.dart';

import '../../../../core/error/failures.dart';

class UpdatePayrollRule {
  final PayrollRulesRepository repository;

  UpdatePayrollRule(this.repository);

  Future<Either<Failure, PayrollRuleEntity>> call(PayrollRuleEntity rule) {
    return repository.updateRule(rule);
  }
}
