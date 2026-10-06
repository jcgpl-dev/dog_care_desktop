import 'package:flutter/material.dart';

class AppDimensions {
  AppDimensions._();

  // Spacing
  static const spacing2 = 2.0;
  static const spacing4 = 4.0;
  static const spacing8 = 8.0;
  static const spacing12 = 12.0;
  static const spacing16 = 16.0;
  static const spacing20 = 20.0;
  static const spacing24 = 24.0;
  static const spacing32 = 32.0;
  static const spacing40 = 40.0;
  static const spacing48 = 48.0;

  // Common padding
  static const paddingSmall = EdgeInsets.all(spacing8);
  static const paddingMedium = EdgeInsets.all(spacing16);
  static const paddingLarge = EdgeInsets.all(spacing24);

  // Horizontal / vertical padding
  static const paddingHorizontalMedium = EdgeInsets.symmetric(
    horizontal: spacing16,
  );

  static const paddingHorizontalLarge = EdgeInsets.symmetric(
    horizontal: spacing24,
  );

  // Border radius
  static const radiusSmall = 6.0;
  static const radiusMedium = 10.0;
  static const radiusLarge = 16.0;
  static const radiusFull = 999.0;

  // Component sizes
  static const buttonHeight = 44.0;
  static const inputHeight = 48.0;

  // Layout
  static const sidebarWidth = 250.0;
  static const maxContentWidth = 1440.0;

  static const loginLogoSize = 64.0;
  static const loginLogoRadius = 18.0;
  static const loginLogoIconSize = 36.0;
  static const loginFormMaxWidth = 440.0;
  static const loginCardPadding = 32.0;
}
