import 'package:dartz/dartz.dart';
import 'package:manzoma/features/payroll/domain/repositories/payroll_details_repository.dart';
import '../entities/payroll_detail_entity.dart';
import '../../../../core/error/failures.dart';

class AddPayrollDetail {
  final PayrollDetailRepository repository;

  AddPayrollDetail(this.repository);

  Future<Either<Failure, PayrollDetailEntity>> call(
      PayrollDetailEntity detail) {
    return repository.addDetail(detail);
  }
}
