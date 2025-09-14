// create_rule_usecase.dart
import 'package:dartz/dartz.dart';
import 'package:manzoma/core/error/failures.dart';
import 'package:manzoma/core/usecases/usecase.dart';
import 'package:manzoma/features/payroll/domain/entities/payroll_rules_entity.dart';
import 'package:manzoma/features/payroll/domain/repositories/payroll_rules_repo.dart';

class CreateRuleUseCase extends UseCase<PayrollRuleEntity, CreateRuleParams> {
  final PayrollRulesRepository repository;

  CreateRuleUseCase(this.repository);

  @override
  Future<Either<Failure, PayrollRuleEntity>> call(CreateRuleParams params) {
    return repository.createRule(
      params.rule,
    );
  }
}

class CreateRuleParams {
  final PayrollRuleEntity rule;

  CreateRuleParams({
    required this.rule,
  });
}
