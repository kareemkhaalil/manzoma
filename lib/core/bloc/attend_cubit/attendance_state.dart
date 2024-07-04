part of 'attendance_cubit.dart'; // Import your state file

abstract class AttendanceState extends Equatable {
  const AttendanceState();

  @override
  List<Object?> get props => [];
}

class AttendanceInitial extends AttendanceState {}

class AttendanceLoading extends AttendanceState {}

class AttendanceSuccess extends AttendanceState {
  final String filePath;
  final List<Map<String, dynamic>> attendanceData;

  const AttendanceSuccess(this.filePath, this.attendanceData);

  @override
  List<Object?> get props => [filePath, attendanceData];

  @override
  String toString() =>
      'AttendanceSuccess { filePath: $filePath, attendanceData: $attendanceData }';
}

class AttendanceFilteredSuccess extends AttendanceState {
  final List<Map<String, dynamic>> filteredAttendanceData;

  const AttendanceFilteredSuccess(this.filteredAttendanceData);

  @override
  List<Object?> get props => [filteredAttendanceData];

  @override
  String toString() =>
      'AttendanceFilteredSuccess { filteredAttendanceData: $filteredAttendanceData }';
}

class AttendanceFailure extends AttendanceState {
  final String error;

  const AttendanceFailure(this.error);

  @override
  List<Object?> get props => [error];

  @override
  String toString() => 'AttendanceFailure { error: $error }';
}
