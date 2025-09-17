// lib/features/employee/presentation/utils/responsive_utils.dart

import 'package:flutter/material.dart';

class ResponsiveUtils {
  static bool isTablet(BuildContext context) {
    return MediaQuery.of(context).size.width > 600;
  }

  static bool isSmallPhone(BuildContext context) {
    return MediaQuery.of(context).size.width < 360;
  }

  static double getResponsivePadding(BuildContext context) {
    if (isTablet(context)) {
      return 24.0;
    } else if (isSmallPhone(context)) {
      return 12.0;
    } else {
      return 16.0;
    }
  }

  static EdgeInsets getResponsivePaddingAll(BuildContext context) {
    final padding = getResponsivePadding(context);
    return EdgeInsets.all(padding);
  }

  static EdgeInsets getResponsivePaddingHorizontal(BuildContext context) {
    final padding = getResponsivePadding(context);
    return EdgeInsets.symmetric(horizontal: padding);
  }

  static EdgeInsets getResponsivePaddingVertical(BuildContext context) {
    final padding = getResponsivePadding(context);
    return EdgeInsets.symmetric(vertical: padding);
  }

  static double getResponsiveFontSize(BuildContext context,
      {double? baseSize}) {
    final size = baseSize ?? 16.0;
    if (isTablet(context)) {
      return size * 1.2;
    } else if (isSmallPhone(context)) {
      return size * 0.9;
    } else {
      return size;
    }
  }

  static double getResponsiveIconSize(BuildContext context,
      {double? baseSize}) {
    final size = baseSize ?? 24.0;
    if (isTablet(context)) {
      return size * 1.15;
    } else if (isSmallPhone(context)) {
      return size * 0.85;
    } else {
      return size;
    }
  }
}
