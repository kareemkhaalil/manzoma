// lib/features/employee/presentation/widgets/bottom_navigation.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:manzoma/core/utils/responsive.util.dart';

class BottomNavigation extends StatelessWidget {
  final List<Map<String, dynamic>> items;
  final int currentIndex;
  final Function(int) onItemTap;

  const BottomNavigation({
    super.key,
    required this.items,
    required this.currentIndex,
    required this.onItemTap,
  });

  @override
  Widget build(BuildContext context) {
    final isTablet = ResponsiveUtils.isTablet(context);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isTablet ? 24 : 16,
        vertical: isTablet ? 16 : 12,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, -8),
            spreadRadius: 0,
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, -4),
          ),
        ],
        border: const Border(
          top: BorderSide(
            color: Color(0xFFE5E7EB),
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(items.length, (index) {
          final item = items[index];
          final isActive = index == currentIndex;

          return GestureDetector(
            onTap: () => onItemTap(index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding: EdgeInsets.symmetric(
                horizontal: isTablet ? 16 : 12,
                vertical: isTablet ? 8 : 6,
              ),
              decoration: BoxDecoration(
                color: isActive
                    ? const Color(0xFF6366F1).withValues(alpha: 0.1)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    isActive
                        ? item['activeIcon'] as IconData
                        : item['icon'] as IconData,
                    color: isActive
                        ? const Color(0xFF6366F1)
                        : const Color(0xFF9CA3AF),
                    size: ResponsiveUtils.getResponsiveIconSize(context,
                        baseSize: 24),
                  ),
                  SizedBox(height: isTablet ? 6 : 4),
                  Text(
                    item['label'] as String,
                    style: TextStyle(
                      fontSize: ResponsiveUtils.getResponsiveFontSize(context,
                          baseSize: 12),
                      color: isActive
                          ? const Color(0xFF6366F1)
                          : const Color(0xFF9CA3AF),
                      fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
