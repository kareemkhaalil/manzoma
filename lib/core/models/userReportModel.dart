class UserReportModel {
  final String name;
  final DateTime? loginDate;
  final DateTime? logoutDate;
  final String attendanceStatus;
  final String employeeId;

  UserReportModel({
    required this.name,
    this.loginDate,
    this.logoutDate,
    required this.attendanceStatus,
    required this.employeeId,
  });

  // Add other necessary methods and constructors
}
