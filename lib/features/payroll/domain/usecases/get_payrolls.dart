import 'package:dartz/dartz.dart';
import '../entities/payroll_entity.dart';
import '../repositories/payroll_repository.dart';
import '../../../../core/error/failures.dart';

class GetPayrolls {
  final PayrollRepository repository;

  GetPayrolls(this.repository);

  Future<Either<Failure, List<PayrollEntity>>> call(String tenantId) {
    return repository.getPayrolls(tenantId);
  }
}
