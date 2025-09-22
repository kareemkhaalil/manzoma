// lib/core/enums/user_role.dart
enum UserRole { superAdmin, cad, branchManager, employee }

extension UserRoleX on UserRole {
  String toValue() {
    switch (this) {
      case UserRole.superAdmin:
        return 'super_admin';
      case UserRole.cad:
        return 'cad';
      case UserRole.employee:
        return 'employee';
      case UserRole.branchManager:
        return 'branchManager';
    }
  }

  static UserRole fromValue(String? value) {
    switch (value) {
      case 'super_admin':
        return UserRole.superAdmin;
      case 'cad':
        return UserRole.cad;
      case 'employee':
        return UserRole.employee;
      case 'branchManager':
        return UserRole.branchManager;
      default:
        // Fallback آمن
        return UserRole.employee;
    }
  }
}
