part of 'attendance_cubit.dart'; // Import your state file

abstract class AttendanceState extends Equatable {
  const AttendanceState();

  @override
  List<Object?> get props => [];
}

class AttendanceInitial extends AttendanceState {}

class AttendanceLoading extends AttendanceState {}

class AttendanceClientDataLoaded extends AttendanceState {
  final ClientModel? clientData;

  AttendanceClientDataLoaded(this.clientData);

  @override
  List<Object> get props => [clientData!];
}

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

class UserReportsLoaded extends AttendanceState {
  final List<UserReportModel> user;

  UserReportsLoaded(this.user);

  @override
  List<Object> get props => [user];
}

class AttendanceFilteredSuccess extends AttendanceState {
  final List<Map<String, dynamic>> filteredAttendanceData;

  const AttendanceFilteredSuccess(this.filteredAttendanceData);

  @override
  List<Object> get props => [filteredAttendanceData];
}

class AttendanceFailure extends AttendanceState {
  final String error;

  const AttendanceFailure(this.error);

  @override
  List<Object?> get props => [error];

  @override
  String toString() => 'AttendanceFailure { error: $error }';
}

class AttendanceExportSuccess extends AttendanceState {
  final String filePath;

  AttendanceExportSuccess(this.filePath);

  @override
  List<Object> get props => [filePath];
}

class AttendanceExportFailure extends AttendanceState {
  final String error;

  AttendanceExportFailure(this.error);

  @override
  List<Object> get props => [error];
}

class UserAttendanceDetailsLoaded extends AttendanceState {
  final List<AttendanceDetails> attendanceDetails;
  final String userName;

  const UserAttendanceDetailsLoaded(this.attendanceDetails, this.userName);

  @override
  List<Object> get props => [attendanceDetails, userName];
}

class AttendanceDetails {
  final DateTime checkInTime;
  final DateTime? checkOutTime;

  AttendanceDetails({
    required this.checkInTime,
    this.checkOutTime,
  });
}
