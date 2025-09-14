// lib/features/employee/presentation/screens/employee_home_screen.dart

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:manzoma/core/storage/shared_pref_helper.dart';
import 'package:manzoma/core/utils/responsive.util.dart';
import 'package:manzoma/features/attendance/presentation/cubit/attendance_cubit.dart';
import 'package:manzoma/features/attendance/presentation/cubit/attendance_state.dart';
import 'package:manzoma/features/employee/presentation/widgets/buttom_navigation.dart';
import 'package:manzoma/features/employee/presentation/widgets/modern_header.dart';
import 'package:manzoma/features/employee/presentation/widgets/attendance_button.dart';
import 'package:manzoma/features/employee/presentation/widgets/quick_actions_grid.dart';
import 'package:manzoma/features/employee/presentation/widgets/performance_summary.dart';
import 'package:manzoma/features/employee/presentation/widgets/settings_menu.dart';

class EmployeeHomeScreen extends StatefulWidget {
  const EmployeeHomeScreen({super.key});

  @override
  State<EmployeeHomeScreen> createState() => _EmployeeHomeScreenState();
}

class _EmployeeHomeScreenState extends State<EmployeeHomeScreen>
    with TickerProviderStateMixin {
  String _userName = "الموظف";
  late Timer _timer;
  DateTime _now = DateTime.now();

  // Animation controllers
  late AnimationController _pulseController;
  late AnimationController _staggeredController;
  late AnimationController _slideController;

  late Animation<double> _pulseAnimation;
  late Animation<Offset> _slideAnimation;
  late List<Animation<double>> _staggeredAnimations;
  late List<Animation<Offset>> _slideAnimations;

  @override
  void initState() {
    super.initState();
    _loadUserData();

    // Clock update
    _now = DateTime.now();
    _timer = Timer.periodic(const Duration(seconds: 30), (_) {
      setState(() => _now = DateTime.now());
    });

    // Pulse animation for attendance button
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();

    _pulseAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeOut),
    );

    // Slide animation for header
    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..forward();

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));

    // Staggered animations for quick actions
    _staggeredController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..forward();

    _staggeredAnimations = List.generate(4, (index) {
      return CurvedAnimation(
        parent: _staggeredController,
        curve: Interval(0.2 * index, 0.6 + 0.1 * index, curve: Curves.easeOut),
      );
    });

    _slideAnimations = List.generate(4, (index) {
      return Tween<Offset>(
        begin: const Offset(0, 0.5),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: _staggeredController,
        curve: Interval(0.2 * index, 0.6 + 0.1 * index, curve: Curves.easeOut),
      ));
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _pulseController.dispose();
    _staggeredController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  void _loadUserData() {
    final user = SharedPrefHelper.getUser();
    if (user != null) {
      setState(() {
        _userName = user.name ?? "الموظف";
      });
    }
  }

  // Sample data for mini bar chart
  final List<double> _weekData = [0.8, 0.6, 0.9, 0.4, 0.7, 0.5, 0.85];
  final List<String> _weekDays = ["S", "M", "T", "W", "T", "F", "S"];

  // Quick actions data
  final List<Map<String, dynamic>> _quickActions = [
    {
      'icon': Icons.insert_chart_outlined,
      'title': 'إحصاءات',
      'color': const Color(0xFF8B5CF6)
    },
    {
      'icon': Icons.history_outlined,
      'title': 'سجل الحضور',
      'color': const Color(0xFF06B6D4)
    },
    {
      'icon': Icons.person_outline,
      'title': 'حسابي',
      'color': const Color(0xFFEC4899)
    },
    {
      'icon': Icons.help_outline,
      'title': 'المساعدة',
      'color': const Color(0xFFF59E0B)
    },
  ];

  // Bottom navigation items
  final List<Map<String, dynamic>> _navItems = [
    {
      "icon": Icons.home_outlined,
      "activeIcon": Icons.home,
      "label": "الرئيسية"
    },
    {
      "icon": Icons.schedule_outlined,
      "activeIcon": Icons.schedule,
      "label": "الحضور"
    },
    {
      "icon": Icons.insert_chart_outlined,
      "activeIcon": Icons.insert_chart,
      "label": "التقارير"
    },
    {
      "icon": Icons.person_outline,
      "activeIcon": Icons.person,
      "label": "حسابي"
    },
  ];

  @override
  Widget build(BuildContext context) {
    final contentPadding = ResponsiveUtils.getResponsivePaddingAll(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: BlocConsumer<AttendanceCubit, AttendanceState>(
          listener: (context, state) {
            if (state is AttendanceLoading) {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (_) =>
                    const Center(child: CircularProgressIndicator()),
              );
            } else {
              Navigator.of(context, rootNavigator: true).pop(); // close loading
            }

            if (state is AttendanceCheckInSuccess) {
              _showCustomDialog("تم تسجيل الحضور بنجاح",
                  color: const Color(0xFF10B981));
            } else if (state is AttendanceCheckOutSuccess) {
              _showCustomDialog("تم تسجيل الانصراف بنجاح",
                  color: const Color(0xFFF59E0B));
            } else if (state is AttendanceError) {
              _showCustomDialog(state.message, color: Colors.red);
            }
          },
          builder: (context, state) {
            final isCheckedIn = state is AttendanceCheckInSuccess;

            return Column(
              children: [
                // Modern animated header
                ModernHeader(
                  userName: _userName,
                  currentTime: _now,
                  onSettingsTap: () => _showSettingsMenu(context),
                  slideAnimation: _slideAnimation,
                ),

                // Body content
                Expanded(
                  child: SingleChildScrollView(
                    padding: contentPadding,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(
                            height:
                                ResponsiveUtils.isTablet(context) ? 32 : 24),

                        // Modern attendance circle
                        AttendanceButton(
                          isCheckedIn: isCheckedIn,
                          onTap: () => _handleAttendanceAction(context, state),
                          pulseAnimation: _pulseAnimation,
                        ),

                        SizedBox(
                            height:
                                ResponsiveUtils.isTablet(context) ? 40 : 32),

                        // Modern quick actions
                        QuickActionsGrid(
                          actions: _quickActions,
                          staggeredAnimations: _staggeredAnimations,
                          slideAnimations: _slideAnimations,
                          onActionTap: _handleQuickAction,
                        ),

                        SizedBox(
                            height:
                                ResponsiveUtils.isTablet(context) ? 32 : 24),

                        // Modern performance summary
                        PerformanceSummary(
                          weekData: _weekData,
                          weekDays: _weekDays,
                          isCheckedIn: isCheckedIn,
                          onViewAllTap: () {
                            try {
                              GoRouter.of(context).go('/reports');
                            } catch (_) {}
                          },
                        ),

                        SizedBox(
                            height:
                                ResponsiveUtils.isTablet(context) ? 32 : 24),
                      ],
                    ),
                  ),
                ),

                // Modern bottom navigation
                BottomNavigation(
                  items: _navItems,
                  currentIndex: 0,
                  onItemTap: _handleNavigationTap,
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  // ================= Actions =================
  void _handleAttendanceAction(BuildContext context, AttendanceState state) {
    final cubit = context.read<AttendanceCubit>();
    final user = SharedPrefHelper.getUser();

    if (user == null) {
      _showCustomDialog("لم يتم العثور على بيانات المستخدم", color: Colors.red);
      return;
    }

    if (state is AttendanceCheckInSuccess) {
      cubit.checkOut(attendanceId: state.attendance.id);
    } else {
      cubit.checkIn(userId: user.id, location: ""); // TODO: حط اللوكيشن الحقيقي
    }
  }

  void _handleQuickAction(String title) {
    _showCustomDialog("تم النقر على: $title", color: const Color(0xFF6366F1));
  }

  void _showCustomDialog(String message, {Color? color}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          backgroundColor: color ?? Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          content: Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
              color: Colors.white,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
              ),
              child: const Text("موافق"),
            ),
          ],
        );
      },
    );
  }

  void _handleNavigationTap(int index) {
    if (index == 1) {
      GoRouter.of(context).go('/employee/attendance');
    } else if (index == 2) {
      GoRouter.of(context).go('/reports');
    } else if (index == 3) {
      GoRouter.of(context).go('/profile');
    }
  }

  void _showSettingsMenu(BuildContext context) {
    SettingsMenu.show(
      context,
      onSettingsTap: () => Navigator.pop(context),
      onLogoutTap: () {
        Navigator.pop(context);
        GoRouter.of(context).go('/login');
      },
    );
  }
}
