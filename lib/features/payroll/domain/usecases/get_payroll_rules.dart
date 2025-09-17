import 'package:dartz/dartz.dart';
import 'package:manzoma/features/payroll/domain/entities/payroll_rules_entity.dart';
import 'package:manzoma/features/payroll/domain/repositories/payroll_rules_repo.dart';

import '../../../../core/error/failures.dart';

class GetPayrollRules {
  final PayrollRulesRepository repository;

  GetPayrollRules(this.repository);

  Future<Either<Failure, List<PayrollRuleEntity>>> call(String tenantId) {
    return repository.getAllRules(tenantId);
  }
}
