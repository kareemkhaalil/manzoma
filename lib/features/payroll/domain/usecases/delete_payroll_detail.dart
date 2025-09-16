import 'package:dartz/dartz.dart';
import 'package:manzoma/features/payroll/domain/repositories/payroll_details_repository.dart';
import '../../../../core/error/failures.dart';

class DeletePayrollDetail {
  final PayrollDetailRepository repository;

  DeletePayrollDetail(this.repository);

  Future<Either<Failure, void>> call(String detailId) {
    return repository.deleteDetail(detailId);
  }
}
