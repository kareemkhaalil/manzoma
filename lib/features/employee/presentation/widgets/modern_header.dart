// lib/features/employee/presentation/widgets/modern_header.dart

import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:manzoma/core/utils/responsive.util.dart';

class ModernHeader extends StatefulWidget {
  final String userName;
  final DateTime currentTime;
  final VoidCallback onSettingsTap;
  final Animation<Offset> slideAnimation;

  const ModernHeader({
    super.key,
    required this.userName,
    required this.currentTime,
    required this.onSettingsTap,
    required this.slideAnimation,
  });

  @override
  State<ModernHeader> createState() => _ModernHeaderState();
}

class _ModernHeaderState extends State<ModernHeader> {
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    // Update time every 30 seconds
    _timer = Timer.periodic(const Duration(seconds: 30), (_) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = ResponsiveUtils.isTablet(context);
    final padding = ResponsiveUtils.getResponsivePaddingAll(context);

    return SlideTransition(
      position: widget.slideAnimation,
      child: Container(
        width: double.infinity,
        padding: padding,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              Color(0xFF6366F1),
              Color(0xFF8B5CF6),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(24),
            bottomRight: Radius.circular(24),
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF6366F1).withValues(alpha: 0.2),
              blurRadius: 20,
              offset: const Offset(0, 8),
              spreadRadius: 2,
            ),
          ],
        ),
        child: Column(
          children: [
            _buildUserInfoSection(context, isTablet),
            SizedBox(height: isTablet ? 16 : 12),
            _buildTimeDisplay(context, isTablet),
          ],
        ),
      ),
    );
  }

  Widget _buildUserInfoSection(BuildContext context, bool isTablet) {
    return Row(
      children: [
        // Modern avatar
        Container(
          width: isTablet ? 60 : 52,
          height: isTablet ? 60 : 52,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.white.withValues(alpha: 0.2),
                Colors.white.withValues(alpha: 0.1),
              ],
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.3),
              width: 1.5,
            ),
          ),
          child: Icon(
            Icons.person,
            color: Colors.white,
            size: ResponsiveUtils.getResponsiveIconSize(context, baseSize: 28),
          ),
        ),
        SizedBox(width: isTablet ? 16 : 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "مرحباً،",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: ResponsiveUtils.getResponsiveFontSize(context,
                      baseSize: 20),
                  fontWeight: FontWeight.w400,
                  shadows: [
                    Shadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
              ),
              Text(
                " ${widget.userName}",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: ResponsiveUtils.getResponsiveFontSize(context,
                      baseSize: 24),
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "${widget.currentTime.day}/${widget.currentTime.month}/${widget.currentTime.year}",
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.9),
                  fontSize: ResponsiveUtils.getResponsiveFontSize(context,
                      baseSize: 15),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        // Modern settings button
        GestureDetector(
          onTap: widget.onSettingsTap,
          child: Container(
            width: isTablet ? 44 : 40,
            height: isTablet ? 44 : 40,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.2),
                width: 1,
              ),
            ),
            child: Icon(
              Icons.more_vert,
              color: Colors.white,
              size:
                  ResponsiveUtils.getResponsiveIconSize(context, baseSize: 22),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTimeDisplay(BuildContext context, bool isTablet) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: isTablet ? 16 : 12,
            vertical: isTablet ? 10 : 8,
          ),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.2),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Icon(
                Icons.access_time,
                color: Colors.white,
                size: ResponsiveUtils.getResponsiveIconSize(context,
                    baseSize: 20),
              ),
              SizedBox(width: isTablet ? 8 : 6),
              Text(
                DateFormat('hh:mm a')
                    .format(widget.currentTime), // ⬅️ ده اللي هيظبط التنسيق
                style: TextStyle(
                  color: Colors.white,
                  fontSize: ResponsiveUtils.getResponsiveFontSize(context,
                      baseSize: 18),
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(width: isTablet ? 12 : 8),
              Expanded(
                child: Text(
                  "اضغط لبدء تسجيل حضورك أو الانصراف",
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.95),
                    fontSize: ResponsiveUtils.getResponsiveFontSize(context,
                        baseSize: 14),
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
