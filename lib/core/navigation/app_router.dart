import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:manzoma/core/enums/user_role.dart';
import 'package:manzoma/core/localization/app_localizations.dart';
import 'package:manzoma/core/localization/cubit/locale_cubit.dart';
import 'package:manzoma/core/storage/shared_pref_helper.dart';
import 'package:manzoma/features/branches/domain/entities/branch_entity.dart';
import 'package:manzoma/features/branches/presentation/screens/branches_edit_screen.dart';
import 'package:manzoma/features/employee/presentation/screens/attendance_screen.dart';
import 'package:manzoma/features/employee/presentation/screens/employee_home_screen.dart';
import 'package:manzoma/features/payroll/presentation/screens/employee_salary_screen.dart';
import 'package:manzoma/features/payroll/presentation/screens/payroll_rules_screen.dart';
import 'package:manzoma/features/users/presentation/screens/users_edit_screen.dart';
import 'package:manzoma/shared/widgets/app_sidebar.dart';
import 'package:manzoma/shared/widgets/app_topbar.dart';
import 'package:manzoma/shared/widgets/splash_screen.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/dashboard/presentation/screens/dashboard_screen.dart';
import '../../features/attendance/presentation/screens/attendance_screen.dart';
import '../../features/payroll/presentation/screens/payroll_screen.dart';
import '../../features/branches/presentation/screens/branches_screen.dart';
import '../../features/branches/presentation/screens/branches_create_screen.dart';
import '../../features/users/presentation/screens/users_screen.dart';
import '../../features/users/presentation/screens/users_create_screen.dart';
import 'package:manzoma/features/reports/presentation/screens/reports_screen.dart';
import 'package:manzoma/features/clients/presentation/screens/clients_screen.dart';
import 'package:manzoma/features/clients/presentation/screens/clients_create_screen.dart';
import '../navigation/route_names.dart';
import '../navigation/navigation_service.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    navigatorKey: NavigationService.navigatorKey,
    initialLocation: RouteNames.splash,
    redirect: (context, state) {
      final user = SharedPrefHelper.getUser();
      final loggedIn = user != null;
      final goingToLogin = state.matchedLocation == RouteNames.login;
      final goingToSplash = state.matchedLocation == RouteNames.splash;

      // نخلي السبلاش دايماً يشتغل
      if (goingToSplash) return null;
      if (!loggedIn && !goingToLogin) return RouteNames.login;
      if (loggedIn && goingToLogin) return RouteNames.dashboard;

      // حماية على بعض الروتس
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
        path: RouteNames.splash,
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),
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
      GoRoute(
        path: RouteNames.payrollSettings,
        name: 'payrollRules',
        builder: (context, state) =>
            const MainAppShell(child: PayrollRulesScreen()),
      ),

      GoRoute(
        path: RouteNames.employeeSalary,
        name: 'employeeSalary',
        builder: (context, state) =>
            const MainAppShell(child: EmployeeSalaryScreen()),
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
        builder: (context, state) => const MainAppShell(
          child: UsersCreateScreen(),
        ),
      ),
      GoRoute(
        path: '/users/edit',
        builder: (context, state) {
          final widget = state.extra as UsersEditScreen;
          return widget;
        },
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
        builder: (context, state) =>
            const MainAppShell(child: BranchesCreateScreen()),
      ),
      GoRoute(
        path: '/branches/edit',
        builder: (context, state) {
          // استلام بيانات الفرع
          final branch = state.extra as BranchEntity;
          return BranchesEditScreen(editingBranch: branch);
        },
      ),

      // Reports Routes
      GoRoute(
        path: RouteNames.reports,
        name: 'reports',
        builder: (context, state) => const MainAppShell(child: ReportsScreen()),
      ),

      GoRoute(
        path: "/employee/home",
        builder: (context, state) => const EmployeeHomeScreen(),
      ),
      GoRoute(
        path: "/employee/attendance",
        builder: (context, state) =>
            const AttendanceEmployeeScreen(), // هنضيفها كمان
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
    return LayoutBuilder(builder: (context, constraints) {
      final isMobile = constraints.maxWidth < 768;
      final isLtr = Directionality.of(context) == TextDirection.ltr;
      final localeCubit = context.watch<LocaleCubit>();
      final isEnglish = localeCubit.state.locale.languageCode;

      if (isMobile) {
        // 📱 Mobile Layout with Drawer
        return Scaffold(
          key: _scaffoldKey,
          appBar: AppTopBar(
            title: AppLocalizations.off(context).dashboard,
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
        // 💻 Desktop Layout with Sidebar (dynamic RTL/LTR)
        return Scaffold(
          body: Row(
            children: [
              if (isEnglish.isNotEmpty)
                // if (isEnglish == 'en') const
                const AppSidebar(isMobile: false),
              Expanded(
                child: Column(
                  children: [
                    AppTopBar(title: AppLocalizations.off(context).dashboard),
                    Expanded(child: widget.child),
                  ],
                ),
              ),
              // if (isEnglish == 'ar') const AppSidebar(isMobile: false),
            ],
          ),
        );
      }
    });
  }
}
