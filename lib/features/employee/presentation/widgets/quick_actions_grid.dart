// lib/features/employee/presentation/widgets/quick_actions_grid.dart

import 'package:flutter/material.dart';
import 'package:manzoma/core/utils/responsive.util.dart';

class QuickActionsGrid extends StatelessWidget {
  final List<Map<String, dynamic>> actions;
  final List<Animation<double>> staggeredAnimations;
  final List<Animation<Offset>> slideAnimations;
  final Function(String) onActionTap;

  const QuickActionsGrid({
    super.key,
    required this.actions,
    required this.staggeredAnimations,
    required this.slideAnimations,
    required this.onActionTap,
  });

  @override
  Widget build(BuildContext context) {
    final isTablet = ResponsiveUtils.isTablet(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: isTablet ? 8.0 : 4.0),
          child: Text(
            "إجراءات سريعة",
            style: TextStyle(
              fontSize:
                  ResponsiveUtils.getResponsiveFontSize(context, baseSize: 20),
              fontWeight: FontWeight.bold,
              color: const Color(0xFF1F2937),
            ),
          ),
        ),
        SizedBox(height: isTablet ? 16 : 12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: isTablet ? 4 : 2,
            crossAxisSpacing: isTablet ? 16 : 12,
            mainAxisSpacing: isTablet ? 16 : 12,
            childAspectRatio: 1.1,
          ),
          itemCount: actions.length,
          itemBuilder: (context, index) {
            final action = actions[index];
            return FadeTransition(
              opacity: staggeredAnimations[index],
              child: SlideTransition(
                position: slideAnimations[index],
                child: _buildActionCard(context, action, isTablet),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildActionCard(
      BuildContext context, Map<String, dynamic> action, bool isTablet) {
    return GestureDetector(
      onTap: () => onActionTap(action['title'] as String),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 16,
              offset: const Offset(0, 8),
              spreadRadius: 0,
            ),
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
          border: Border.all(
            color: const Color(0xFFE5E7EB),
            width: 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: isTablet ? 56 : 48,
              height: isTablet ? 56 : 48,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    (action['color'] as Color).withValues(alpha: 0.15),
                    (action['color'] as Color).withValues(alpha: 0.05),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: (action['color'] as Color).withValues(alpha: 0.2),
                  width: 1,
                ),
              ),
              child: Icon(
                action['icon'] as IconData,
                color: action['color'] as Color,
                size: ResponsiveUtils.getResponsiveIconSize(context,
                    baseSize: 28),
              ),
            ),
            SizedBox(height: isTablet ? 12 : 8),
            Text(
              action['title'] as String,
              style: TextStyle(
                fontSize: ResponsiveUtils.getResponsiveFontSize(context,
                    baseSize: 14),
                fontWeight: FontWeight.w600,
                color: const Color(0xFF374151),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
