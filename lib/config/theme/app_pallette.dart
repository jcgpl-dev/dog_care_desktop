import 'package:flutter/material.dart';

@immutable
class AppPalette extends ThemeExtension<AppPalette> {
  const AppPalette({
    required this.background,
    required this.surface,
    required this.surfaceVariant,
    required this.surfaceHigh,
    required this.fieldBackground,
    required this.textPrimary,
    required this.textSecondary,
    required this.textHint,
    required this.textDisabled,
    required this.border,
    required this.borderStrong,
    required this.primary,
    required this.onPrimary,
    required this.primaryHover,
    required this.primaryText,
    required this.primaryContainer,
    required this.onPrimaryContainer,
    required this.secondary,
    required this.secondaryContainer,
    required this.success,
    required this.successContainer,
    required this.warning,
    required this.warningContainer,
    required this.error,
    required this.errorContainer,
    required this.info,
    required this.infoContainer,
    required this.inverseSurface,
    required this.onInverseSurface,
    required this.accentGreen,
    required this.accentBlue,
    required this.accentPink,
    required this.accentAmber,
    required this.accentPurple,
    required this.accentOrange,
  });

  // Surfaces
  final Color background; // page
  final Color surface; // cards, table, panels
  final Color surfaceVariant; // hover rows, subtle fills
  final Color surfaceHigh; // popups, floating layers
  final Color fieldBackground; // text inputs

  // Text and icons
  final Color textPrimary;
  final Color textSecondary;
  final Color textHint; // placeholders
  final Color textDisabled; // exempt from contrast rules

  // Borders
  final Color border; // decorative: cards, dividers
  final Color borderStrong; // controls: inputs, checkboxes (3:1)

  // Brand
  final Color primary; // fills: buttons, selected states
  final Color onPrimary; // text/icons ON a primary fill
  final Color primaryHover;
  final Color primaryText; // green TEXT, links, icons, focus rings
  final Color primaryContainer; // soft green background
  final Color onPrimaryContainer;
  final Color secondary;
  final Color secondaryContainer;

  // Semantic: the main color is for text/icons, the container is for badges
  final Color success;
  final Color successContainer;
  final Color warning;
  final Color warningContainer;
  final Color error;
  final Color errorContainer;
  final Color info;
  final Color infoContainer;

  // Floating dark layers: snackbars, tooltips, bulk-action bar
  final Color inverseSurface;
  final Color onInverseSurface;

  final Color accentGreen;
  final Color accentBlue;
  final Color accentPink;
  final Color accentAmber;
  final Color accentPurple;
  final Color accentOrange;

  static const light = AppPalette(
    background: Color(0xFFF2F5F3),
    surface: Color(0xFFFFFFFF),
    surfaceVariant: Color(0xFFEDF2EE),
    surfaceHigh: Color(0xFFFFFFFF),
    fieldBackground: Color(0xFFFFFFFF),
    textPrimary: Color(0xFF1A1C1A),
    textSecondary: Color(0xFF505853),
    textHint: Color(0xFF6A726C),
    textDisabled: Color(0xFF8D948F),
    border: Color(0xFFDCE2DD),
    borderStrong: Color(0xFF8C958E),
    primary: Color(0xFF46B47F),
    onPrimary: Color(0xFF0B1F14),
    primaryHover: Color(0xFF3AA06F),
    primaryText: Color(0xFF1F7A4D),
    primaryContainer: Color(0xFFDDF3E6),
    onPrimaryContainer: Color(0xFF0F4A2B),
    secondary: Color(0xFF00695C),
    secondaryContainer: Color(0xFFE0EDEB),
    success: Color(0xFF2A7430),
    successContainer: Color(0xFFE6F4E8),
    warning: Color(0xFF7A4F00),
    warningContainer: Color(0xFFFFF3D6),
    error: Color(0xFFC62828),
    errorContainer: Color(0xFFFCE8E8),
    info: Color(0xFF1565C0),
    infoContainer: Color(0xFFE3EEFB),
    inverseSurface: Color(0xFF232A26),
    onInverseSurface: Color(0xFFF2F5F3),
    accentGreen: Color(0xFF1F7A4D),
    accentBlue: Color(0xFF1E63C9),
    accentPink: Color(0xFFC2185B),
    accentAmber: Color(0xFF9A5B00),
    accentPurple: Color(0xFF7B3FBF),
    accentOrange: Color(0xFFC2410C),
  );

  static const dark = AppPalette(
    background: Color(0xFF0E1210),
    surface: Color(0xFF161B18),
    surfaceVariant: Color(0xFF1E2421),
    surfaceHigh: Color(0xFF262D29),
    fieldBackground: Color(0xFF111513),
    textPrimary: Color(0xFFE6ECE8),
    textSecondary: Color(0xFFA3ADA7),
    textHint: Color(0xFF8A948E),
    textDisabled: Color(0xFF646D67),
    border: Color(0xFF2B332F),
    borderStrong: Color(0xFF69736C),
    primary: Color(0xFF46B47F),
    onPrimary: Color(0xFF0B1F14),
    primaryHover: Color(0xFF5CC796),
    primaryText: Color(0xFF6FCF9E),
    primaryContainer: Color(0xFF1E3A2D),
    onPrimaryContainer: Color(0xFFBFEBD3),
    secondary: Color(0xFF5CC8B8),
    secondaryContainer: Color(0xFF233A35),
    success: Color(0xFF6CD08A),
    successContainer: Color(0xFF17301F),
    warning: Color(0xFFFFC857),
    warningContainer: Color(0xFF3A2F10),
    error: Color(0xFFFF8F87),
    errorContainer: Color(0xFF3B1D1D),
    info: Color(0xFF7DB2F2),
    infoContainer: Color(0xFF17283D),
    inverseSurface: Color(0xFF2F3733),
    onInverseSurface: Color(0xFFE6ECE8),
    accentGreen: Color(0xFF6FCF9E),
    accentBlue: Color(0xFF7DB2F2),
    accentPink: Color(0xFFF48FB1),
    accentAmber: Color(0xFFFFC857),
    accentPurple: Color(0xFFC3A1F2),
    accentOrange: Color(0xFFFFA270),
  );

  ColorScheme toColorScheme(Brightness brightness) {
    final isLight = brightness == Brightness.light;
    return ColorScheme(
      brightness: brightness,
      primary: primary,
      onPrimary: onPrimary,
      primaryContainer: primaryContainer,
      onPrimaryContainer: onPrimaryContainer,
      secondary: secondary,
      onSecondary: isLight ? Colors.white : const Color(0xFF00201B),
      secondaryContainer: secondaryContainer,
      onSecondaryContainer: textPrimary,
      error: error,
      onError: isLight ? Colors.white : const Color(0xFF3B0A07),
      errorContainer: errorContainer,
      onErrorContainer: error,
      surface: surface,
      onSurface: textPrimary,
      onSurfaceVariant: textSecondary,
      surfaceContainerLowest: background,
      surfaceContainer: surfaceVariant,
      surfaceContainerHigh: surfaceHigh,
      outline: borderStrong,
      outlineVariant: border,
      inverseSurface: inverseSurface,
      onInverseSurface: onInverseSurface,
      inversePrimary: const Color(0xFF6FCF9E),
      scrim: Colors.black,
      surfaceTint: Colors.transparent,
    );
  }

  @override
  AppPalette copyWith() => this;

  @override
  AppPalette lerp(ThemeExtension<AppPalette>? other, double t) =>
      other is! AppPalette ? this : (t < 0.5 ? this : other);
}

extension AppPaletteContext on BuildContext {
  AppPalette get colors {
    final theme = Theme.of(this);
    return theme.extension<AppPalette>() ??
        (theme.brightness == Brightness.dark
            ? AppPalette.dark
            : AppPalette.light);
  }
}
