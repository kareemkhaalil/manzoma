// import 'package:dartz/dartz.dart';
// import 'package:manzoma/features/payroll/domain/entities/payroll_detail_entity.dart';

// import '../../../../core/error/failures.dart';

// abstract class PayrollDetailsRepository {
//   Future<Either<Failure, List<PayrollDetailEntity>>> getPayrollDetails(
//       String payrollId);
//   Future<Either<Failure, PayrollDetailEntity>> createPayrollDetail(
//       PayrollDetailEntity detail);
//   // ... other methods for update, delete etc.
// }
import 'package:dartz/dartz.dart';
import '../entities/payroll_detail_entity.dart';
import '../../../../core/error/failures.dart';

abstract class PayrollDetailRepository {
  Future<Either<Failure, List<PayrollDetailEntity>>> getDetailsByPayrollId(
      String payrollId);
  Future<Either<Failure, PayrollDetailEntity>> addDetail(
      PayrollDetailEntity detail);
  Future<Either<Failure, void>> deleteDetail(String detailId);
}
