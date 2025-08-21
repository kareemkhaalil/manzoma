import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/attendance_entity.dart';
import '../repositories/attendance_repository.dart';

class GetAttendanceHistoryUseCase implements UseCase<List<AttendanceEntity>, GetAttendanceHistoryParams> {
  final AttendanceRepository repository;

  GetAttendanceHistoryUseCase(this.repository);

  @override
  Future<Either<Failure, List<AttendanceEntity>>> call(GetAttendanceHistoryParams params) async {
    return await repository.getAttendanceHistory(
      userId: params.userId,
      startDate: params.startDate,
      endDate: params.endDate,
      limit: params.limit,
      offset: params.offset,
    );
  }
}

class GetAttendanceHistoryParams extends Equatable {
  final String userId;
  final DateTime? startDate;
  final DateTime? endDate;
  final int? limit;
  final int? offset;

  const GetAttendanceHistoryParams({
    required this.userId,
    this.startDate,
    this.endDate,
    this.limit,
    this.offset,
  });

  @override
  List<Object?> get props => [userId, startDate, endDate, limit, offset];
}

