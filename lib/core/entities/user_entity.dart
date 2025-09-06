import 'package:equatable/equatable.dart';
import 'package:manzoma/core/enums/user_role.dart';

class UserEntity extends Equatable {
  final String id;
  final String tenantId;
  final String? branchId;
  final String? email;
  final String? password; // إذا كان مطلوب
  final UserRole role; // 👈 Enum
  final String? name;
  final String? phone;
  final String? avatar;
  final double baseSalary;
  final List<dynamic> allowances;
  final List<dynamic> deductions;
  final Map<String, dynamic> workSchedule;
  final bool isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const UserEntity({
    required this.id,
    required this.tenantId,
    this.branchId,
    this.email,
    this.password,
    required this.role,
    this.name,
    this.phone,
    this.avatar,
    this.baseSalary = 0.0,
    this.allowances = const [],
    this.deductions = const [],
    this.workSchedule = const {},
    this.isActive = true,
    this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        tenantId,
        branchId,
        email,
        password,
        role,
        name,
        phone,
        avatar,
        baseSalary,
        allowances,
        deductions,
        workSchedule,
        isActive,
        createdAt,
        updatedAt,
      ];

  // Helper getters
  bool get isSuperAdmin => role == UserRole.superAdmin;
  bool get isCad => role == UserRole.cad;
  bool get isEmployee => role == UserRole.employee;

  String get displayName => name ?? email ?? 'Unknown User';

  bool get hasBasicInfo => name != null && email != null;
}
