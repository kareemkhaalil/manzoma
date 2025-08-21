import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/attendance_entity.dart';
import '../repositories/attendance_repository.dart';

class CheckInUseCase implements UseCase<AttendanceEntity, CheckInParams> {
  final AttendanceRepository repository;

  CheckInUseCase(this.repository);

  @override
  Future<Either<Failure, AttendanceEntity>> call(CheckInParams params) async {
    return await repository.checkIn(
      userId: params.userId,
      location: params.location,
      notes: params.notes,
    );
  }
}

class CheckInParams extends Equatable {
  final String userId;
  final String location;
  final String? notes;

  const CheckInParams({
    required this.userId,
    required this.location,
    this.notes,
  });

  @override
  List<Object?> get props => [userId, location, notes];
}

