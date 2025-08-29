import 'package:flutter/material.dart';

class ResponsiveUtils {
  static bool isSmallScreen(BuildContext context) {
    return MediaQuery.of(context).size.width < 600;
  }

  static bool isTablet(BuildContext context) {
    return MediaQuery.of(context).size.width >= 600 &&
        MediaQuery.of(context).size.width < 1200;
  }

  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= 1200;
  }

  static double getScreenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  static double getScreenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  static EdgeInsets getResponsivePadding(BuildContext context) {
    final width = getScreenWidth(context);
    if (width < 400) return const EdgeInsets.all(12.0);
    if (width < 600) return const EdgeInsets.all(16.0);
    if (width < 900) return const EdgeInsets.all(20.0);
    return const EdgeInsets.all(24.0);
  }

  static double getResponsiveFontSize(
    BuildContext context,
    double baseFontSize,
  ) {
    final width = getScreenWidth(context);
    final scale = width / 400; // Base scale for 400px width
    return baseFontSize * scale.clamp(0.8, 1.4);
  }

  static double getResponsiveIconSize(
    BuildContext context,
    double baseIconSize,
  ) {
    final width = getScreenWidth(context);
    final scale = width / 400;
    return baseIconSize * scale.clamp(0.8, 1.3);
  }

  static double getMaxWidth(BuildContext context) {
    final width = getScreenWidth(context);
    if (width > 600) return 600; // Max width for larger screens
    return width;
  }
}
