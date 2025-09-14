import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/employee_rules_repository.dart';

class AssignRuleToEmployeeUseCase implements UseCase<void, AssignRuleParams> {
  final EmployeeRulesRepository repository;

  AssignRuleToEmployeeUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(AssignRuleParams params) async {
    return await repository.assignRuleToEmployee(
      userId: params.userId,
      ruleId: params.ruleId,
    );
  }
}

class AssignRuleParams extends Equatable {
  final String userId;
  final String ruleId;

  const AssignRuleParams({required this.userId, required this.ruleId});

  @override
  List<Object?> get props => [userId, ruleId];
}
