import 'package:dartz/dartz.dart';
import 'package:manzoma/features/payroll/domain/repositories/payroll_details_repository.dart';
import '../entities/payroll_detail_entity.dart';
import '../../../../core/error/failures.dart';

class GetPayrollDetails {
  final PayrollDetailRepository repository;

  GetPayrollDetails(this.repository);

  Future<Either<Failure, List<PayrollDetailEntity>>> call(String payrollId) {
    return repository.getDetailsByPayrollId(payrollId);
  }
}
