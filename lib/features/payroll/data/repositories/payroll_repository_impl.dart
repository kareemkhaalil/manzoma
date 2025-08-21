import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/payroll_entity.dart';
import '../../domain/repositories/payroll_repository.dart';
import '../datasources/payroll_remote_datasource.dart';

class PayrollRepositoryImpl implements PayrollRepository {
  final PayrollRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  PayrollRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, PayrollEntity>> createPayroll({
    required String userId,
    required String period,
    required double basicSalary,
    double allowances = 0,
    double deductions = 0,
    double overtime = 0,
    double bonus = 0,
    required int workingDays,
    required int actualWorkingDays,
    String? notes,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final payroll = await remoteDataSource.createPayroll(
          userId: userId,
          period: period,
          basicSalary: basicSalary,
          allowances: allowances,
          deductions: deductions,
          overtime: overtime,
          bonus: bonus,
          workingDays: workingDays,
          actualWorkingDays: actualWorkingDays,
          notes: notes,
        );
        return Right(payroll);
      } on ServerException catch (e) {
        return Left(ServerFailure(
          message: e.message,
          statusCode: e.statusCode,
        ));
      }
    } else {
      return const Left(NetworkFailure(
        message: 'لا يوجد اتصال بالإنترنت',
      ));
    }
  }

  @override
  Future<Either<Failure, List<PayrollEntity>>> getPayrollHistory({
    required String userId,
    String? period,
    int? limit,
    int? offset,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final payrollList = await remoteDataSource.getPayrollHistory(
          userId: userId,
          period: period,
          limit: limit,
          offset: offset,
        );
        return Right(payrollList);
      } on ServerException catch (e) {
        return Left(ServerFailure(
          message: e.message,
          statusCode: e.statusCode,
        ));
      }
    } else {
      return const Left(NetworkFailure(
        message: 'لا يوجد اتصال بالإنترنت',
      ));
    }
  }

  @override
  Future<Either<Failure, List<PayrollEntity>>> getAllPayrolls({
    String? period,
    String? status,
    int? limit,
    int? offset,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final payrollList = await remoteDataSource.getAllPayrolls(
          period: period,
          status: status,
          limit: limit,
          offset: offset,
        );
        return Right(payrollList);
      } on ServerException catch (e) {
        return Left(ServerFailure(
          message: e.message,
          statusCode: e.statusCode,
        ));
      }
    } else {
      return const Left(NetworkFailure(
        message: 'لا يوجد اتصال بالإنترنت',
      ));
    }
  }

  @override
  Future<Either<Failure, PayrollEntity>> updatePayroll({
    required String payrollId,
    double? basicSalary,
    double? allowances,
    double? deductions,
    double? overtime,
    double? bonus,
    int? workingDays,
    int? actualWorkingDays,
    String? status,
    String? notes,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final payroll = await remoteDataSource.updatePayroll(
          payrollId: payrollId,
          basicSalary: basicSalary,
          allowances: allowances,
          deductions: deductions,
          overtime: overtime,
          bonus: bonus,
          workingDays: workingDays,
          actualWorkingDays: actualWorkingDays,
          status: status,
          notes: notes,
        );
        return Right(payroll);
      } on ServerException catch (e) {
        return Left(ServerFailure(
          message: e.message,
          statusCode: e.statusCode,
        ));
      }
    } else {
      return const Left(NetworkFailure(
        message: 'لا يوجد اتصال بالإنترنت',
      ));
    }
  }

  @override
  Future<Either<Failure, void>> deletePayroll({required String payrollId}) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.deletePayroll(payrollId: payrollId);
        return const Right(null);
      } on ServerException catch (e) {
        return Left(ServerFailure(
          message: e.message,
          statusCode: e.statusCode,
        ));
      }
    } else {
      return const Left(NetworkFailure(
        message: 'لا يوجد اتصال بالإنترنت',
      ));
    }
  }

  @override
  Future<Either<Failure, PayrollEntity>> approvePayroll({
    required String payrollId,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final payroll = await remoteDataSource.approvePayroll(
          payrollId: payrollId,
        );
        return Right(payroll);
      } on ServerException catch (e) {
        return Left(ServerFailure(
          message: e.message,
          statusCode: e.statusCode,
        ));
      }
    } else {
      return const Left(NetworkFailure(
        message: 'لا يوجد اتصال بالإنترنت',
      ));
    }
  }

  @override
  Future<Either<Failure, PayrollEntity>> markAsPaid({
    required String payrollId,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final payroll = await remoteDataSource.markAsPaid(
          payrollId: payrollId,
        );
        return Right(payroll);
      } on ServerException catch (e) {
        return Left(ServerFailure(
          message: e.message,
          statusCode: e.statusCode,
        ));
      }
    } else {
      return const Left(NetworkFailure(
        message: 'لا يوجد اتصال بالإنترنت',
      ));
    }
  }
}

