import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:huma_plus/core/enums/user_role.dart';
import 'package:huma_plus/core/storage/shared_pref_helper.dart';
import 'package:huma_plus/shared/widgets/app_sidebar.dart';
import 'package:huma_plus/shared/widgets/app_topbar.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/dashboard/presentation/screens/dashboard_screen.dart';
import '../../features/attendance/presentation/screens/attendance_screen.dart';
import '../../features/payroll/presentation/screens/payroll_screen.dart';
import '../../features/branches/presentation/screens/branches_screen.dart';
import '../../features/branches/presentation/screens/branches_create_screen.dart';
import '../../features/users/presentation/screens/users_screen.dart';
import '../../features/users/presentation/screens/users_create_screen.dart';
import 'package:huma_plus/features/reports/presentation/screens/reports_screen.dart';
import 'package:huma_plus/features/clients/presentation/screens/clients_screen.dart';
import 'package:huma_plus/features/clients/presentation/screens/clients_create_screen.dart';
import '../navigation/route_names.dart';
import '../navigation/navigation_service.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    navigatorKey: NavigationService.navigatorKey,
    initialLocation: RouteNames.login,
    redirect: (context, state) {
      final user = SharedPrefHelper.getUser();
      final loggedIn = user != null;
      final goingToLogin = state.matchedLocation == RouteNames.login;

      if (!loggedIn && !goingToLogin) return RouteNames.login;
      if (loggedIn && goingToLogin) return RouteNames.dashboard;

      // حراسة سريعة على بعض الروتس (اختياري)
      final role = user?.role ?? UserRole.employee;
      final loc = state.matchedLocation;

      if (loc == RouteNames.clients && role != UserRole.superAdmin) {
        return RouteNames.dashboard;
      }
      if ((loc == RouteNames.branches ||
              loc == RouteNames.users ||
              loc == RouteNames.reports) &&
          role == UserRole.employee) {
        return RouteNames.dashboard;
      }
      return null;
    },
    routes: [
      GoRoute(
        path: RouteNames.login,
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      // Dashboard Routes
      GoRoute(
        path: RouteNames.dashboard,
        name: 'dashboard',
        builder: (context, state) => const MainAppShell(
          child: DashboardScreen(),
        ),
      ),

      // Attendance Routes
      GoRoute(
        path: RouteNames.attendance,
        name: 'attendance',
        builder: (context, state) =>
            const MainAppShell(child: AttendanceScreen()),
      ),

      // Payroll Routes
      GoRoute(
        path: RouteNames.payroll,
        name: 'payroll',
        builder: (context, state) => const MainAppShell(child: PayrollScreen()),
      ),

      // Clients Routes (Super Admin only)
      GoRoute(
        path: RouteNames.clients,
        name: 'clients',
        builder: (context, state) => const MainAppShell(child: ClientsScreen()),
      ),
      GoRoute(
        path: RouteNames.createClient,
        name: 'createClient',
        builder: (context, state) => const ClientsCreateScreen(),
      ),

      // Users Routes (Super Admin & CAD only)
      GoRoute(
        path: RouteNames.users,
        name: 'users',
        builder: (context, state) => const MainAppShell(child: UsersScreen()),
      ),
      GoRoute(
        path: RouteNames.createUser,
        name: 'createUser',
        builder: (context, state) => UsersCreateScreen(
          isSuperAdmin: SharedPrefHelper.getUser()?.role == UserRole.superAdmin,
        ),
      ),

      // Branches Routes (Super Admin & CAD only)
      GoRoute(
        path: RouteNames.branches,
        name: 'branches',
        builder: (context, state) =>
            const MainAppShell(child: BranchesScreen()),
      ),
      GoRoute(
        path: RouteNames.createBranch,
        name: 'createBranch',
        builder: (context, state) => const BranchesCreateScreen(),
      ),

      // Reports Routes
      GoRoute(
        path: RouteNames.reports,
        name: 'reports',
        builder: (context, state) => const MainAppShell(child: ReportsScreen()),
      ),
    ],
  );
}

class MainAppShell extends StatefulWidget {
  final Widget child;

  const MainAppShell({
    super.key,
    required this.child,
  });

  @override
  State<MainAppShell> createState() => _MainAppShellState();
}

class _MainAppShellState extends State<MainAppShell> {
  UserRole _userRole = UserRole.employee;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _loadUserRole();
  }

  Future<void> _loadUserRole() async {
    final user = SharedPrefHelper.getUser();
    if (user != null) {
      setState(() {
        _userRole = user.role;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 768;

        if (isMobile) {
          // Mobile Layout with Drawer
          return Scaffold(
            key: _scaffoldKey,
            appBar: AppBar(
              title: const Text('HumaPlus'),
              backgroundColor: Theme.of(context).primaryColor,
              foregroundColor: Colors.white,
              leading: IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () => _scaffoldKey.currentState?.openDrawer(),
              ),
            ),
            drawer: Drawer(
              child: AppSidebar(
                isMobile: true,
                onItemTap: () => Navigator.of(context).pop(),
              ),
            ),
            body: widget.child,
          );
        } else {
          // Desktop Layout with Sidebar
          return Scaffold(
            body: Row(
              children: [
                // Sidebar Navigation
                const AppSidebar(isMobile: false),
                // Main Content Area
                Expanded(
                  child: Column(
                    children: [
                      const AppTopBar(title: 'Dashboard'),
                      Expanded(child: widget.child),
                    ],
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}

// Placeholder widgets - will be implemented in their respective files
// class AppSidebar extends StatelessWidget {
//   const AppSidebar({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: 250,
//       color: Colors.grey[100],
//       child: const Center(
//         child: Text('Sidebar - To be implemented'),
//       ),
//     );
//   }
// }
