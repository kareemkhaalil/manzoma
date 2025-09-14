import 'package:equatable/equatable.dart';

enum AttendanceStatus {
  present,
  absent,
  late,
  earlyLeave,
}

class AttendanceEntity extends Equatable {
  final String id;
  final String userId;
  final DateTime date;
  final DateTime? checkInTime;
  final DateTime? checkOutTime;
  final AttendanceStatus status;
  final int? workingHours;
  final int? overtimeHours;
  final String? notes;
  final String? location;
  final DateTime createdAt;
  final DateTime updatedAt;

  const AttendanceEntity({
    required this.id,
    required this.userId,
    required this.date,
    this.checkInTime,
    this.checkOutTime,
    required this.status,
    this.workingHours,
    this.overtimeHours,
    this.notes,
    this.location,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        userId,
        date,
        checkInTime,
        checkOutTime,
        status,
        workingHours,
        overtimeHours,
        notes,
        location,
        createdAt,
        updatedAt,
      ];
}
