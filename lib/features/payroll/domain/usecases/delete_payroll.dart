import 'package:dartz/dartz.dart';
import '../repositories/payroll_repository.dart';
import '../../../../core/error/failures.dart';

class DeletePayroll {
  final PayrollRepository repository;

  DeletePayroll(this.repository);

  Future<Either<Failure, void>> call(String id) {
    return repository.deletePayroll(id);
  }
}
