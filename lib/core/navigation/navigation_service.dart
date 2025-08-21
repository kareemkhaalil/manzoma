import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NavigationService {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static BuildContext? get context => navigatorKey.currentContext;

  // Navigation methods
  static void goTo(String route, {Object? extra}) {
    if (context != null) {
      context!.go(route, extra: extra);
    }
  }

  static void pushTo(String route, {Object? extra}) {
    if (context != null) {
      context!.push(route, extra: extra);
    }
  }

  static void pop() {
    if (context != null) {
      context!.pop();
    }
  }

  static void popUntil(String route) {
    if (context != null) {
      while (
          context!.canPop() && GoRouterState.of(context!).uri.path != route) {
        context!.pop();
      }
    }
  }

  // Role-based navigation helpers
  static void goToDashboard() => goTo('/dashboard');
  static void goToLogin() => goTo('/login');
  static void goToAttendance() => goTo('/attendance');
  static void goToPayroll() => goTo('/payroll');
  static void goToBranches() => goTo('/branches');
  static void goToUsers() => goTo('/users');
  static void goToReports() => goTo('/reports');
}
