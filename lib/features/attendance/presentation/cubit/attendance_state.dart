import 'package:equatable/equatable.dart';
import '../../domain/entities/attendance_entity.dart';

abstract class AttendanceState extends Equatable {
  const AttendanceState();

  @override
  List<Object?> get props => [];
}

class AttendanceInitial extends AttendanceState {}

class AttendanceLoading extends AttendanceState {}

class AttendanceCheckInSuccess extends AttendanceState {
  final AttendanceEntity attendance;

  const AttendanceCheckInSuccess({required this.attendance});

  @override
  List<Object> get props => [attendance];
}

class AttendanceCheckOutSuccess extends AttendanceState {
  final AttendanceEntity attendance;

  const AttendanceCheckOutSuccess({required this.attendance});

  @override
  List<Object> get props => [attendance];
}

class AttendanceHistoryLoaded extends AttendanceState {
  final List<AttendanceEntity> attendanceList;
  final bool hasReachedMax;

  const AttendanceHistoryLoaded({
    required this.attendanceList,
    this.hasReachedMax = false,
  });

  @override
  List<Object> get props => [attendanceList, hasReachedMax];

  AttendanceHistoryLoaded copyWith({
    List<AttendanceEntity>? attendanceList,
    bool? hasReachedMax,
  }) {
    return AttendanceHistoryLoaded(
      attendanceList: attendanceList ?? this.attendanceList,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }
}

class AttendanceError extends AttendanceState {
  final String message;

  const AttendanceError({required this.message});

  @override
  List<Object> get props => [message];
}

