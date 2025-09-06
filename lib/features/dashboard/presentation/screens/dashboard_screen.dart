import 'package:flutter/material.dart';
import 'package:manzoma/core/localization/app_localizations.dart';
import 'package:manzoma/core/storage/shared_pref_helper.dart';
import '../../../../shared/widgets/app_sidebar.dart';
import '../../../../shared/widgets/app_topbar.dart';
import 'package:manzoma/core/enums/user_role.dart';
import 'package:flutter_localization/flutter_localization.dart';

import '../widgets/dashboard_stats.dart';
import '../widgets/recent_activities.dart';
import '../widgets/quick_actions.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  UserRole _userRole = UserRole.employee; // Default role

  @override
  void initState() {
    super.initState();
    _loadUserRole();
  }

  Future<void> _loadUserRole() async {
    final user = SharedPrefHelper.getUser();
    print('Loaded user from SharedPref: $user');
    if (user != null) {
      setState(() {
        _userRole = user.role;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // AppSidebar(userRole: _userRole), // Handled in MainAppShell
          Expanded(
            child: Column(
              children: [
                // AppTopBar(title: 'Dashboard'), // Handled in MainAppShell
                Expanded(
                  child: DashboardContent(userRole: _userRole),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class DashboardContent extends StatelessWidget {
  final UserRole userRole;

  const DashboardContent({
    super.key,
    required this.userRole,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Welcome Section
          _buildWelcomeSection(context),
          const SizedBox(height: 24),

          // Stats Cards
          DashboardStats(userRole: userRole),
          const SizedBox(height: 24),

          // Quick Actions and Recent Activities
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 1,
                child: QuickActions(userRole: userRole),
              ),
              const SizedBox(width: 24),
              Expanded(
                flex: 2,
                child: RecentActivities(userRole: userRole),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomeSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Theme.of(context).colorScheme.primary,
            Theme.of(context).colorScheme.primary.withOpacity(0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _getWelcomeMessage(context),
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _getWelcomeSubtitle(context),
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            _getWelcomeIcon(),
            size: 80,
            color: Colors.white.withOpacity(0.3),
          ),
        ],
      ),
    );
  }

  String _getWelcomeMessage(BuildContext context) {
    switch (userRole) {
      case UserRole.superAdmin:
        return FlutterLocalization.instance.getString(context, 'welcomeSuperAdmin');
      case UserRole.cad:
        return FlutterLocalization.instance.getString(context, 'welcomeAdmin');
      case UserRole.employee:
        return FlutterLocalization.instance.getString(context, 'welcomeEmployee');
    }
  }

  String _getWelcomeSubtitle(BuildContext context) {
    switch (userRole) {
      case UserRole.superAdmin:
        return FlutterLocalization.instance.getString(context, 'welcomeSubtitleSuperAdmin');
      case UserRole.cad:
        return FlutterLocalization.instance.getString(context, 'welcomeSubtitleAdmin');
      case UserRole.employee:
        return FlutterLocalization.instance.getString(context, 'welcomeSubtitleEmployee');
    }
  }

  IconData _getWelcomeIcon() {
    switch (userRole) {
      case UserRole.superAdmin:
        return Icons.admin_panel_settings;
      case UserRole.cad:
        return Icons.business_center;
      case UserRole.employee:
        return Icons.person;
    }
  }
}
