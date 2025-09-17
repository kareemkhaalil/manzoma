import 'package:dartz/dartz.dart';
import '../entities/payroll_entity.dart';
import '../repositories/payroll_repository.dart';
import '../../../../core/error/failures.dart';

class GetPayrollById {
  final PayrollRepository repository;

  GetPayrollById(this.repository);

  Future<Either<Failure, PayrollEntity>> call(String id) {
    return repository.getPayrollById(id);
  }
}
