import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/attendance_entity.dart';
import '../repositories/attendance_repository.dart';

class CheckOutUseCase implements UseCase<AttendanceEntity, CheckOutParams> {
  final AttendanceRepository repository;

  CheckOutUseCase(this.repository);

  @override
  Future<Either<Failure, AttendanceEntity>> call(CheckOutParams params) async {
    return await repository.checkOut(
      attendanceId: params.attendanceId,
      notes: params.notes,
    );
  }
}

class CheckOutParams extends Equatable {
  final String attendanceId;
  final String? notes;

  const CheckOutParams({
    required this.attendanceId,
    this.notes,
  });

  @override
  List<Object?> get props => [attendanceId, notes];
}

