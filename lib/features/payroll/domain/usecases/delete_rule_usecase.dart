// delete_rule_usecase.dart
import 'package:dartz/dartz.dart';
import 'package:manzoma/core/error/failures.dart';
import 'package:manzoma/core/usecases/usecase.dart';
import '../repositories/payroll_repository.dart';

class DeleteRuleUseCase extends UseCase<void, DeleteRuleParams> {
  final PayrollRepository repository;

  DeleteRuleUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(DeleteRuleParams params) {
    return repository.deleteRule(params.ruleId);
  }
}

class DeleteRuleParams {
  final String ruleId;

  DeleteRuleParams(this.ruleId);
}
