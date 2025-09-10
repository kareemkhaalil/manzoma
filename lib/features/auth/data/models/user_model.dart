// lib/features/auth/data/models/user_model.dart
import 'package:manzoma/core/enums/user_role.dart';
import 'package:manzoma/core/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.tenantId,
    super.branchId,
    super.email,
    required super.role,
    super.name,
    super.phone,
    super.avatar,
    super.baseSalary,
    super.allowances,
    super.deductions,
    super.workSchedule,
    super.isActive,
    super.createdAt,
    super.updatedAt,
  });

  // ⬅️ استخدم enum في القراءة من الـ JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      tenantId: json['tenant_id'] as String,
      branchId: json['branch_id'] as String?,
      email: json['email'] as String?,
      role: UserRoleX.fromValue(json['role'] as String? ?? 'employee'),
      name: json['name'] as String?,
      phone: json['phone'] as String?,
      avatar: json['avatar'] as String?,
      baseSalary: json['base_salary'] != null
          ? (double.tryParse(json['base_salary'].toString()) ?? 0.0)
          : 0.0,
      allowances: (json['allowances'] as List?)?.toList() ?? const [],
      deductions: (json['deductions'] as List?)?.toList() ?? const [],
      workSchedule:
          (json['work_schedule'] as Map?)?.cast<String, dynamic>() ?? const {},
      isActive: json['is_active'] as bool? ?? true,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString())
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'].toString())
          : null,
    );
  }

  // ⬅️ اكتب enum كـ String للحفظ
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tenant_id': tenantId,
      'branch_id': branchId,
      'email': email,
      'role': role.toValue(),
      'name': name,
      'phone': phone,
      'avatar': avatar,
      'base_salary': baseSalary,
      'allowances': allowances,
      'deductions': deductions,
      'work_schedule': workSchedule,
      'is_active': isActive,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  UserEntity toEntity() {
    return UserEntity(
      id: id,
      tenantId: tenantId,
      email: email,
      role: role,
      name: name,
      phone: phone,
      isActive: isActive,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  // ⬅️ دي اللي كانت ناقصة
  factory UserModel.fromEntity(UserEntity e) {
    return UserModel(
      id: e.id,
      tenantId: e.tenantId,
      branchId: e.branchId,
      email: e.email,
      role: e.role,
      name: e.name,
      phone: e.phone,
      avatar: e.avatar,
      baseSalary: e.baseSalary,
      allowances: e.allowances,
      deductions: e.deductions,
      workSchedule: e.workSchedule,
      isActive: e.isActive,
      createdAt: e.createdAt,
      updatedAt: e.updatedAt,
    );
  }

  UserModel copyWith({
    String? id,
    String? tenantId,
    String? branchId,
    String? email,
    UserRole? role,
    String? name,
    String? phone,
    String? avatar,
    double? baseSalary,
    List<dynamic>? allowances,
    List<dynamic>? deductions,
    Map<String, dynamic>? workSchedule,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      tenantId: tenantId ?? this.tenantId,
      branchId: branchId ?? this.branchId,
      email: email ?? this.email,
      role: role ?? this.role,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      avatar: avatar ?? this.avatar,
      baseSalary: baseSalary ?? this.baseSalary,
      allowances: allowances ?? this.allowances,
      deductions: deductions ?? this.deductions,
      workSchedule: workSchedule ?? this.workSchedule,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
