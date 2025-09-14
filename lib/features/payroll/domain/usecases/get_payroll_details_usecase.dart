import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/payroll_detail_entity.dart';
import '../repositories/payroll_details_repository.dart'; // You will create this repository

class GetPayrollDetailsUseCase
    implements UseCase<List<PayrollDetailEntity>, GetPayrollDetailsParams> {
  final PayrollDetailsRepository repository;

  GetPayrollDetailsUseCase(this.repository);

  @override
  Future<Either<Failure, List<PayrollDetailEntity>>> call(
      GetPayrollDetailsParams params) async {
    return await repository.getPayrollDetails(params.payrollId);
  }
}

class GetPayrollDetailsParams extends Equatable {
  final String payrollId;

  const GetPayrollDetailsParams({required this.payrollId});

  @override
  List<Object?> get props => [payrollId];
}
