import 'package:dartz/dartz.dart';
import 'package:manzoma/features/payroll/domain/entities/payroll_rules_entity.dart';
import 'package:manzoma/features/payroll/domain/repositories/payroll_rules_repo.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';

class GetAllRulesUseCase implements UseCase<List<PayrollRuleEntity>, NoParams> {
  final PayrollRulesRepository repository;

  GetAllRulesUseCase(this.repository);

  @override
  Future<Either<Failure, List<PayrollRuleEntity>>> call(NoParams params) async {
    return await repository.getAllRules();
  }
}
