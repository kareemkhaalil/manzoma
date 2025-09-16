import 'package:dartz/dartz.dart';
import '../entities/payroll_entity.dart';
import '../repositories/payroll_repository.dart';
import '../../../../core/error/failures.dart';

class CreatePayroll {
  final PayrollRepository repository;

  CreatePayroll(this.repository);

  Future<Either<Failure, PayrollEntity>> call(PayrollEntity payroll) {
    return repository.createPayroll(payroll);
  }
}
