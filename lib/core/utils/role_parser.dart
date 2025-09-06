import 'package:manzoma/core/enums/user_role.dart';

/// Parses heterogeneous role strings into a canonical UserRole enum.
UserRole parseUserRole(dynamic rawRole) {
  final roleStr = (rawRole ?? '').toString().toLowerCase().trim();

  switch (roleStr) {
    case 'superadmin':
    case 'superAdmin':
    case 'super_admin':
    case 'super-admin':
    case 'owner':
    case 'root':
      return UserRole.superAdmin;

    case 'cad':
    case 'admin':
    case 'clientadmin':
    case 'client_admin':
    case 'client-admin':
    case 'company_admin':
    case 'company-admin':
      return UserRole.cad;

    case 'employee':
    case 'staff':
    case 'user':
    default:
      return UserRole.employee;
  }
}
