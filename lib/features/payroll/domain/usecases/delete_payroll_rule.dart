import 'package:dartz/dartz.dart';
import 'package:manzoma/features/payroll/domain/repositories/payroll_rules_repo.dart';
import '../../../../core/error/failures.dart';

class DeletePayrollRule {
  final PayrollRulesRepository repository;

  DeletePayrollRule(this.repository);

  Future<Either<Failure, void>> call(String ruleId) {
    return repository.deleteRule(ruleId);
  }
}
