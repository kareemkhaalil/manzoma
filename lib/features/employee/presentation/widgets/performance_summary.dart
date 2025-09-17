// lib/features/employee/presentation/widgets/performance_summary.dart

import 'package:flutter/material.dart';
import 'package:manzoma/core/utils/responsive.util.dart';

class PerformanceSummary extends StatelessWidget {
  final List<double> weekData;
  final List<String> weekDays;
  final bool isCheckedIn;
  final VoidCallback onViewAllTap;

  const PerformanceSummary({
    super.key,
    required this.weekData,
    required this.weekDays,
    required this.isCheckedIn,
    required this.onViewAllTap,
  });

  @override
  Widget build(BuildContext context) {
    final isTablet = ResponsiveUtils.isTablet(context);
    const primaryColor = Color(0xFF6366F1);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 20,
            offset: const Offset(0, 10),
            spreadRadius: 0,
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 6,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: const Color(0xFFE5E7EB),
          width: 1,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(isTablet ? 24 : 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context, isTablet, primaryColor),
            SizedBox(height: isTablet ? 24 : 20),
            _buildChart(context, isTablet, primaryColor),
            SizedBox(height: isTablet ? 24 : 20),
            _buildStats(context, isTablet),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isTablet, Color primaryColor) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(isTablet ? 12 : 10),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                primaryColor.withValues(alpha: 0.15),
                primaryColor.withValues(alpha: 0.05),
              ],
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: primaryColor.withValues(alpha: 0.2),
              width: 1,
            ),
          ),
          child: Icon(
            Icons.show_chart,
            color: primaryColor,
            size: ResponsiveUtils.getResponsiveIconSize(context, baseSize: 24),
          ),
        ),
        SizedBox(width: isTablet ? 12 : 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "ملخص الأداء",
                style: TextStyle(
                  fontSize: ResponsiveUtils.getResponsiveFontSize(context,
                      baseSize: 20),
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1F2937),
                ),
              ),
              Text(
                "آخر 7 أيام",
                style: TextStyle(
                  fontSize: ResponsiveUtils.getResponsiveFontSize(context,
                      baseSize: 14),
                  color: const Color(0xFF6B7280),
                ),
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: onViewAllTap,
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: isTablet ? 16 : 12,
              vertical: isTablet ? 8 : 6,
            ),
            decoration: BoxDecoration(
              color: primaryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              "عرض الكل",
              style: TextStyle(
                color: primaryColor,
                fontSize: ResponsiveUtils.getResponsiveFontSize(context,
                    baseSize: 14),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildChart(BuildContext context, bool isTablet, Color primaryColor) {
    return Container(
      height: isTablet ? 120 : 100,
      padding: EdgeInsets.symmetric(horizontal: isTablet ? 8 : 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: List.generate(weekData.length, (index) {
          final value = weekData[index];
          return Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: isTablet ? 6 : 4),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  AnimatedContainer(
                    duration: Duration(milliseconds: 800 + (index * 100)),
                    curve: Curves.easeOutCubic,
                    height: (isTablet ? 80 : 60) * value,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          primaryColor.withValues(alpha: 0.9),
                          primaryColor.withValues(alpha: 0.6),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                      borderRadius: BorderRadius.circular(
                        isTablet ? 12 : 8,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: primaryColor.withValues(alpha: 0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: isTablet ? 12 : 8),
                  Text(
                    weekDays[index],
                    style: TextStyle(
                      fontSize: ResponsiveUtils.getResponsiveFontSize(context,
                          baseSize: 13),
                      color: const Color(0xFF6B7280),
                      fontWeight: FontWeight.w500,
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

  Widget _buildStats(BuildContext context, bool isTablet) {
    return Row(
      children: [
        _buildStatCard(
          context,
          "حضور اليوم",
          isCheckedIn ? "تم" : "لم يتم",
          Icons.login,
          const Color(0xFF10B981),
          isTablet,
        ),
        SizedBox(width: isTablet ? 12 : 8),
        _buildStatCard(
          context,
          "إجمالي الساعات",
          "8:00",
          Icons.access_time,
          const Color(0xFFF59E0B),
          isTablet,
        ),
        SizedBox(width: isTablet ? 12 : 8),
        _buildStatCard(
          context,
          "غياب",
          "0",
          Icons.cancel_outlined,
          const Color(0xFFEF4444),
          isTablet,
        ),
      ],
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String title,
    String value,
    IconData icon,
    Color color,
    bool isTablet,
  ) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(isTablet ? 16 : 12),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: color.withValues(alpha: 0.15),
            width: 1,
          ),
        ),
        child: Column(
          children: [
            Container(
              width: isTablet ? 40 : 32,
              height: isTablet ? 40 : 32,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: color,
                size: ResponsiveUtils.getResponsiveIconSize(context,
                    baseSize: 20),
              ),
            ),
            SizedBox(height: isTablet ? 8 : 6),
            Text(
              title,
              style: TextStyle(
                fontSize: ResponsiveUtils.getResponsiveFontSize(context,
                    baseSize: 12),
                color: const Color(0xFF6B7280),
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: isTablet ? 4 : 2),
            Text(
              value,
              style: TextStyle(
                fontSize: ResponsiveUtils.getResponsiveFontSize(context,
                    baseSize: 16),
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
