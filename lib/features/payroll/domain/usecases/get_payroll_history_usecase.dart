import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/payroll_entity.dart';
import '../repositories/payroll_repository.dart';

class GetPayrollHistoryUseCase implements UseCase<List<PayrollEntity>, GetPayrollHistoryParams> {
  final PayrollRepository repository;

  GetPayrollHistoryUseCase(this.repository);

  @override
  Future<Either<Failure, List<PayrollEntity>>> call(GetPayrollHistoryParams params) async {
    return await repository.getPayrollHistory(
      userId: params.userId,
      period: params.period,
      limit: params.limit,
      offset: params.offset,
    );
  }
}

class GetPayrollHistoryParams extends Equatable {
  final String userId;
  final String? period;
  final int? limit;
  final int? offset;

  const GetPayrollHistoryParams({
    required this.userId,
    this.period,
    this.limit,
    this.offset,
  });

  @override
  List<Object?> get props => [userId, period, limit, offset];
}

