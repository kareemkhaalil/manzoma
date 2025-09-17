// lib/features/employee/presentation/widgets/attendance_button.dart

import 'package:flutter/material.dart';
import 'package:manzoma/core/utils/responsive.util.dart';

class AttendanceButton extends StatefulWidget {
  final bool isCheckedIn;
  final VoidCallback onTap;
  final Animation<double> pulseAnimation;

  const AttendanceButton({
    super.key,
    required this.isCheckedIn,
    required this.onTap,
    required this.pulseAnimation,
  });

  @override
  State<AttendanceButton> createState() => _AttendanceButtonState();
}

class _AttendanceButtonState extends State<AttendanceButton> {
  @override
  Widget build(BuildContext context) {
    final isTablet = ResponsiveUtils.isTablet(context);
    final isSmallPhone = ResponsiveUtils.isSmallPhone(context);
    final circleSize = isTablet ? 220.0 : (isSmallPhone ? 160.0 : 180.0);
    const primaryColor = Color(0xFF6366F1);
    const checkedInColor = Color(0xFF10B981);

    return Center(
      child: SizedBox(
        width: circleSize + 80,
        height: circleSize + 80,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Modern pulse effect
            AnimatedBuilder(
              animation: widget.pulseAnimation,
              builder: (context, child) {
                final value = widget.pulseAnimation.value;
                final opacity = (1 - value).clamp(0.0, 1.0);
                final sizeFactor = 1 + value * 1.5;

                return Opacity(
                  opacity: opacity * 0.4,
                  child: Container(
                    width: circleSize * sizeFactor,
                    height: circleSize * sizeFactor,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          (widget.isCheckedIn ? checkedInColor : primaryColor)
                              .withValues(alpha: 0.2 * opacity),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),

            // Second pulse layer
            AnimatedBuilder(
              animation: widget.pulseAnimation,
              builder: (context, child) {
                final value = (widget.pulseAnimation.value + 0.5) % 1.0;
                final opacity = (1 - value).clamp(0.0, 1.0);
                final sizeFactor = 1 + value * 1.2;

                return Opacity(
                  opacity: opacity * 0.3,
                  child: Container(
                    width: circleSize * sizeFactor,
                    height: circleSize * sizeFactor,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          (widget.isCheckedIn ? checkedInColor : primaryColor)
                              .withValues(alpha: 0.15 * opacity),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),

            // Main attendance button
            GestureDetector(
              onTap: widget.onTap,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 600),
                curve: Curves.easeOutCubic,
                width: circleSize,
                height: circleSize,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: widget.isCheckedIn
                        ? [const Color(0xFF34D399), const Color(0xFF10B981)]
                        : [const Color(0xFF818CF8), const Color(0xFF6366F1)],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color:
                          (widget.isCheckedIn ? checkedInColor : primaryColor)
                              .withValues(alpha: 0.3),
                      blurRadius: widget.isCheckedIn ? 32 : 24,
                      offset: const Offset(0, 12),
                      spreadRadius: widget.isCheckedIn ? 8 : 4,
                    ),
                    BoxShadow(
                      color:
                          (widget.isCheckedIn ? checkedInColor : primaryColor)
                              .withValues(alpha: 0.2),
                      blurRadius: 16,
                      offset: const Offset(0, 8),
                    ),
                  ],
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.2),
                    width: 2,
                  ),
                ),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 400),
                        transitionBuilder:
                            (Widget child, Animation<double> animation) {
                          return ScaleTransition(
                            scale: animation,
                            child: RotationTransition(
                              turns: animation,
                              child: child,
                            ),
                          );
                        },
                        child: Icon(
                          widget.isCheckedIn
                              ? Icons.logout_rounded
                              : Icons.login_rounded,
                          key: ValueKey<bool>(widget.isCheckedIn),
                          size: ResponsiveUtils.getResponsiveIconSize(
                            context,
                            baseSize: widget.isCheckedIn ? 56 : 48,
                          ),
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: isTablet ? 12 : 8),
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        child: Text(
                          widget.isCheckedIn ? "تسجيل انصراف" : "تسجيل حضور",
                          key: ValueKey<bool>(widget.isCheckedIn),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: ResponsiveUtils.getResponsiveFontSize(
                              context,
                              baseSize: widget.isCheckedIn ? 22 : 18,
                            ),
                            fontWeight: FontWeight.bold,
                            shadows: [
                              Shadow(
                                color: Colors.black.withValues(alpha: 0.2),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: isTablet ? 8 : 6),
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        child: Text(
                          widget.isCheckedIn ? "اضغط للخروج" : "اضغط للدخول",
                          key: ValueKey<bool>(widget.isCheckedIn),
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.9),
                            fontSize: ResponsiveUtils.getResponsiveFontSize(
                              context,
                              baseSize: isSmallPhone ? 11 : 12,
                            ),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
