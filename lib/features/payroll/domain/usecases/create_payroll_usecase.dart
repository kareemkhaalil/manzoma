import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/payroll_entity.dart';
import '../repositories/payroll_repository.dart';

class CreatePayrollUseCase implements UseCase<PayrollEntity, CreatePayrollParams> {
  final PayrollRepository repository;

  CreatePayrollUseCase(this.repository);

  @override
  Future<Either<Failure, PayrollEntity>> call(CreatePayrollParams params) async {
    return await repository.createPayroll(
      userId: params.userId,
      period: params.period,
      basicSalary: params.basicSalary,
      allowances: params.allowances,
      deductions: params.deductions,
      overtime: params.overtime,
      bonus: params.bonus,
      workingDays: params.workingDays,
      actualWorkingDays: params.actualWorkingDays,
      notes: params.notes,
    );
  }
}

class CreatePayrollParams extends Equatable {
  final String userId;
  final String period;
  final double basicSalary;
  final double allowances;
  final double deductions;
  final double overtime;
  final double bonus;
  final int workingDays;
  final int actualWorkingDays;
  final String? notes;

  const CreatePayrollParams({
    required this.userId,
    required this.period,
    required this.basicSalary,
    this.allowances = 0,
    this.deductions = 0,
    this.overtime = 0,
    this.bonus = 0,
    required this.workingDays,
    required this.actualWorkingDays,
    this.notes,
  });

  @override
  List<Object?> get props => [
        userId,
        period,
        basicSalary,
        allowances,
        deductions,
        overtime,
        bonus,
        workingDays,
        actualWorkingDays,
        notes,
      ];
}

