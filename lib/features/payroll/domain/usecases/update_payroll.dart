import 'package:dartz/dartz.dart';
import '../entities/payroll_entity.dart';
import '../repositories/payroll_repository.dart';
import '../../../../core/error/failures.dart';

class UpdatePayroll {
  final PayrollRepository repository;

  UpdatePayroll(this.repository);

  Future<Either<Failure, PayrollEntity>> call(PayrollEntity payroll) {
    return repository.updatePayroll(payroll);
  }
}
