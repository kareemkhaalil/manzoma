import 'package:flutter/material.dart';
import 'package:huma_plus/core/enums/user_role.dart';

class NavigationItem {
  final String title;
  final String route;
  final IconData icon;
  final List<UserRole> allowedRoles;
  final List<NavigationItem>? subItems;

  const NavigationItem({
    required this.title,
    required this.route,
    required this.icon,
    required this.allowedRoles,
    this.subItems,
  });
}

class RoleBasedNavigation {
  static const List<NavigationItem> navigationItems = [
    NavigationItem(
      title: 'Dashboard',
      route: '/dashboard',
      icon: Icons.dashboard,
      allowedRoles: [UserRole.superAdmin, UserRole.cad, UserRole.employee],
    ),
    NavigationItem(
      title: 'Attendance',
      route: '/attendance',
      icon: Icons.access_time,
      allowedRoles: [UserRole.superAdmin, UserRole.cad, UserRole.employee],
      subItems: [
        NavigationItem(
          title: 'Check In/Out',
          route: '/attendance',
          icon: Icons.login,
          allowedRoles: [UserRole.employee],
        ),
        NavigationItem(
          title: 'Attendance History',
          route: '/attendance/history',
          icon: Icons.history,
          allowedRoles: [UserRole.superAdmin, UserRole.cad, UserRole.employee],
        ),
        NavigationItem(
          title: 'Attendance Reports',
          route: '/attendance/report',
          icon: Icons.assessment,
          allowedRoles: [UserRole.superAdmin, UserRole.cad],
        ),
      ],
    ),
    NavigationItem(
      title: 'Payroll',
      route: '/payroll',
      icon: Icons.payment,
      allowedRoles: [UserRole.superAdmin, UserRole.cad, UserRole.employee],
      subItems: [
        NavigationItem(
          title: 'My Payroll',
          route: '/payroll',
          icon: Icons.account_balance_wallet,
          allowedRoles: [UserRole.employee],
        ),
        NavigationItem(
          title: 'Payroll Management',
          route: '/payroll',
          icon: Icons.manage_accounts,
          allowedRoles: [UserRole.superAdmin, UserRole.cad],
        ),
        NavigationItem(
          title: 'Payroll Settings',
          route: '/payroll/settings',
          icon: Icons.settings,
          allowedRoles: [UserRole.superAdmin, UserRole.cad],
        ),
      ],
    ),
    NavigationItem(
      title: 'Branches',
      route: '/branches',
      icon: Icons.business,
      allowedRoles: [UserRole.superAdmin, UserRole.cad],
      subItems: [
        NavigationItem(
          title: 'All Branches',
          route: '/branches',
          icon: Icons.location_city,
          allowedRoles: [UserRole.superAdmin, UserRole.cad],
        ),
        NavigationItem(
          title: 'Add Branch',
          route: '/branches/create',
          icon: Icons.add_location,
          allowedRoles: [UserRole.superAdmin, UserRole.cad],
        ),
      ],
    ),
    NavigationItem(
      title: 'Clients',
      route: '/clients',
      icon: Icons.business_center,
      allowedRoles: [UserRole.superAdmin],
      subItems: [
        NavigationItem(
          title: 'All Clients',
          route: '/clients',
          icon: Icons.view_list,
          allowedRoles: [UserRole.superAdmin],
        ),
        NavigationItem(
          title: 'Add Client',
          route: '/clients/create',
          icon: Icons.add_business,
          allowedRoles: [UserRole.superAdmin],
        ),
      ],
    ),
    NavigationItem(
      title: 'Users',
      route: '/users',
      icon: Icons.people,
      allowedRoles: [UserRole.superAdmin, UserRole.cad],
      subItems: [
        NavigationItem(
          title: 'All Users',
          route: '/users',
          icon: Icons.group,
          allowedRoles: [UserRole.superAdmin, UserRole.cad],
        ),
        NavigationItem(
          title: 'Add User',
          route: '/users/create',
          icon: Icons.person_add,
          allowedRoles: [UserRole.superAdmin, UserRole.cad],
        ),
      ],
    ),
    NavigationItem(
      title: 'Reports',
      route: '/reports',
      icon: Icons.analytics,
      allowedRoles: [UserRole.superAdmin, UserRole.cad],
      subItems: [
        NavigationItem(
          title: 'Attendance Reports',
          route: '/reports/attendance',
          icon: Icons.schedule,
          allowedRoles: [UserRole.superAdmin, UserRole.cad],
        ),
        NavigationItem(
          title: 'Payroll Reports',
          route: '/reports/payroll',
          icon: Icons.money,
          allowedRoles: [UserRole.superAdmin, UserRole.cad],
        ),
      ],
    ),
    NavigationItem(
      title: 'Settings',
      route: '/settings',
      icon: Icons.settings,
      allowedRoles: [UserRole.superAdmin, UserRole.cad],
      subItems: [
        NavigationItem(
          title: 'Profile',
          route: '/settings/profile',
          icon: Icons.person,
          allowedRoles: [UserRole.superAdmin, UserRole.cad, UserRole.employee],
        ),
        NavigationItem(
          title: 'Company Settings',
          route: '/settings/company',
          icon: Icons.business_center,
          allowedRoles: [UserRole.superAdmin, UserRole.cad],
        ),
      ],
    ),
  ];

  static List<NavigationItem> getNavigationItemsForRole(UserRole role) {
    return navigationItems.where((item) {
      return item.allowedRoles.contains(role);
    }).map((item) {
      if (item.subItems != null) {
        final filteredSubItems = item.subItems!
            .where((subItem) => subItem.allowedRoles.contains(role))
            .toList();
        return NavigationItem(
          title: item.title,
          route: item.route,
          icon: item.icon,
          allowedRoles: item.allowedRoles,
          subItems: filteredSubItems.isNotEmpty ? filteredSubItems : null,
        );
      }
      return item;
    }).toList();
  }

  static bool canAccessRoute(String route, UserRole role) {
    for (final item in navigationItems) {
      if (item.route == route && item.allowedRoles.contains(role)) {
        return true;
      }
      if (item.subItems != null) {
        for (final subItem in item.subItems!) {
          if (subItem.route == route && subItem.allowedRoles.contains(role)) {
            return true;
          }
        }
      }
    }
    return false;
  }
}
