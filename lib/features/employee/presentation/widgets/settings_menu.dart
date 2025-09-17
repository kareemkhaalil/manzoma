// lib/features/employee/presentation/widgets/settings_menu.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SettingsMenu extends StatelessWidget {
  final VoidCallback onSettingsTap;
  final VoidCallback onLogoutTap;

  const SettingsMenu({
    super.key,
    required this.onSettingsTap,
    required this.onLogoutTap,
  });

  static void show(
    BuildContext context, {
    required VoidCallback onSettingsTap,
    required VoidCallback onLogoutTap,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => SettingsMenu(
        onSettingsTap: onSettingsTap,
        onLogoutTap: onLogoutTap,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Padding(
        padding: EdgeInsets.only(
          top: 24,
          bottom: MediaQuery.of(context).viewInsets.bottom + 24,
          left: 24,
          right: 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFFE5E7EB),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 24),
            _buildSettingsItem(
              context,
              icon: Icons.settings,
              iconColor: const Color(0xFF6366F1),
              title: "الإعدادات",
              onTap: onSettingsTap,
            ),
            const SizedBox(height: 8),
            _buildSettingsItem(
              context,
              icon: Icons.logout,
              iconColor: const Color(0xFFEF4444),
              title: "تسجيل الخروج",
              onTap: onLogoutTap,
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsItem(
    BuildContext context, {
    required IconData icon,
    required Color iconColor,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: iconColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          icon,
          color: iconColor,
        ),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Color(0xFF1F2937),
        ),
      ),
      onTap: onTap,
    );
  }
}
