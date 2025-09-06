import 'package:flutter/material.dart';
import '../../core/localization/app_localizations.dart';

class DirectionHelper {
  /// Get text direction based on current locale
  static TextDirection getTextDirection(BuildContext context) {
    final localizations = AppLocalizations.instance(context);
    return localizations?.locale.languageCode == 'ar'
        ? TextDirection.rtl
        : TextDirection.ltr;
  }

  /// Check if current locale is RTL
  static bool isRTL(BuildContext context) {
    final localizations = AppLocalizations.instance(context);
    return localizations?.locale.languageCode == 'ar';
  }

  /// Get appropriate alignment based on text direction
  static Alignment getStartAlignment(BuildContext context) {
    return isRTL(context) ? Alignment.centerRight : Alignment.centerLeft;
  }

  static Alignment getEndAlignment(BuildContext context) {
    return isRTL(context) ? Alignment.centerLeft : Alignment.centerRight;
  }

  /// Get appropriate CrossAxisAlignment based on text direction
  static CrossAxisAlignment getStartCrossAxisAlignment(BuildContext context) {
    return isRTL(context) ? CrossAxisAlignment.end : CrossAxisAlignment.start;
  }

  static CrossAxisAlignment getEndCrossAxisAlignment(BuildContext context) {
    return isRTL(context) ? CrossAxisAlignment.start : CrossAxisAlignment.end;
  }

  /// Get appropriate MainAxisAlignment based on text direction
  static MainAxisAlignment getStartMainAxisAlignment(BuildContext context) {
    return isRTL(context) ? MainAxisAlignment.end : MainAxisAlignment.start;
  }

  static MainAxisAlignment getEndMainAxisAlignment(BuildContext context) {
    return isRTL(context) ? MainAxisAlignment.start : MainAxisAlignment.end;
  }

  /// Get appropriate TextAlign based on text direction
  static TextAlign getStartTextAlign(BuildContext context) {
    return isRTL(context) ? TextAlign.right : TextAlign.left;
  }

  static TextAlign getEndTextAlign(BuildContext context) {
    return isRTL(context) ? TextAlign.left : TextAlign.right;
  }

  /// Get appropriate EdgeInsets for padding/margin
  static EdgeInsets getDirectionalPadding({
    double? start,
    double? end,
    double? top,
    double? bottom,
    required BuildContext context,
  }) {
    if (isRTL(context)) {
      return EdgeInsets.only(
        left: end ?? 0,
        right: start ?? 0,
        top: top ?? 0,
        bottom: bottom ?? 0,
      );
    } else {
      return EdgeInsets.only(
        left: start ?? 0,
        right: end ?? 0,
        top: top ?? 0,
        bottom: bottom ?? 0,
      );
    }
  }

  /// Get appropriate BorderRadius for directional borders
  static BorderRadius getDirectionalBorderRadius({
    double? topStart,
    double? topEnd,
    double? bottomStart,
    double? bottomEnd,
    required BuildContext context,
  }) {
    if (isRTL(context)) {
      return BorderRadius.only(
        topLeft: Radius.circular(topEnd ?? 0),
        topRight: Radius.circular(topStart ?? 0),
        bottomLeft: Radius.circular(bottomEnd ?? 0),
        bottomRight: Radius.circular(bottomStart ?? 0),
      );
    } else {
      return BorderRadius.only(
        topLeft: Radius.circular(topStart ?? 0),
        topRight: Radius.circular(topEnd ?? 0),
        bottomLeft: Radius.circular(bottomStart ?? 0),
        bottomRight: Radius.circular(bottomEnd ?? 0),
      );
    }
  }

  /// Wrap widget with appropriate Directionality
  static Widget wrapWithDirectionality(BuildContext context, Widget child) {
    return Directionality(
      textDirection: getTextDirection(context),
      child: child,
    );
  }

  /// Get icon for directional navigation (back/forward)
  static IconData getBackIcon(BuildContext context) {
    return isRTL(context) ? Icons.arrow_forward : Icons.arrow_back;
  }

  static IconData getForwardIcon(BuildContext context) {
    return isRTL(context) ? Icons.arrow_back : Icons.arrow_forward;
  }

  /// Get appropriate icon for menu/drawer
  static IconData getMenuIcon(BuildContext context) {
    return isRTL(context) ? Icons.menu : Icons.menu;
  }

  /// Get appropriate positioning for floating elements
  static double? getStartPosition(BuildContext context, double position) {
    return isRTL(context) ? null : position;
  }

  static double? getEndPosition(BuildContext context, double position) {
    return isRTL(context) ? position : null;
  }
}

/// Extension methods for easier usage
extension DirectionalContext on BuildContext {
  bool get isRTL => DirectionHelper.isRTL(this);
  TextDirection get textDirection => DirectionHelper.getTextDirection(this);

  Alignment get startAlignment => DirectionHelper.getStartAlignment(this);
  Alignment get endAlignment => DirectionHelper.getEndAlignment(this);

  CrossAxisAlignment get startCrossAxis =>
      DirectionHelper.getStartCrossAxisAlignment(this);
  CrossAxisAlignment get endCrossAxis =>
      DirectionHelper.getEndCrossAxisAlignment(this);

  MainAxisAlignment get startMainAxis =>
      DirectionHelper.getStartMainAxisAlignment(this);
  MainAxisAlignment get endMainAxis =>
      DirectionHelper.getEndMainAxisAlignment(this);

  TextAlign get startTextAlign => DirectionHelper.getStartTextAlign(this);
  TextAlign get endTextAlign => DirectionHelper.getEndTextAlign(this);

  IconData get backIcon => DirectionHelper.getBackIcon(this);
  IconData get forwardIcon => DirectionHelper.getForwardIcon(this);
}
