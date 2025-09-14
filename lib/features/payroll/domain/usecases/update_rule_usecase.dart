import 'package:dartz/dartz.dart';
import 'package:manzoma/core/error/failures.dart';
import 'package:manzoma/core/usecases/usecase.dart';
import 'package:manzoma/features/payroll/domain/entities/payroll_rules_entity.dart';
import 'package:manzoma/features/payroll/domain/repositories/payroll_rules_repo.dart';
import '../repositories/payroll_repository.dart';

class UpdateRuleUseCase extends UseCase<PayrollRuleEntity, UpdateRuleParams> {
  final PayrollRulesRepository repository;

  UpdateRuleUseCase(this.repository);

  @override
  Future<Either<Failure, PayrollRuleEntity>> call(UpdateRuleParams params) {
    return repository.updateRule(
      ruleId: params.ruleId,
      name: params.name,
      description: params.description,
      value: params.value,
      type: params.type,
    );
  }
}

class UpdateRuleParams {
  final String ruleId;
  final String name;
  final String? description;
  final double value;
  final String type;

  UpdateRuleParams({
    required this.ruleId,
    required this.name,
    this.description,
    required this.value,
    required this.type,
  });
}
