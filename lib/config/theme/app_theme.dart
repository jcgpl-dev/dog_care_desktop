import 'package:dog_care_desktop/config/theme/app_component_themes.dart';
import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_dimensions.dart';
import 'app_text_styles.dart';

class AppTheme {
  AppTheme._();

  static final ColorScheme _lightScheme = ColorScheme.fromSeed(
    seedColor: AppColors.primary,
    brightness: Brightness.light,
    surface: AppColors.surface,
    surfaceContainer: AppColors.surfaceVariant,
  ).copyWith(primary: AppColors.primary, onPrimary: Colors.white);

  static final ColorScheme _darkScheme = ColorScheme.fromSeed(
    seedColor: AppColors.primary,
    brightness: Brightness.dark,
    surface: const Color(0xFF1E1E1E),
    surfaceContainer: const Color(0xFF252525),
  ).copyWith(primary: AppColors.primary, onPrimary: Colors.white);

  // LIGHT THEME
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    fontFamily: AppTextStyles.fontFamily,
    brightness: Brightness.light,

    colorScheme: _lightScheme,

    scaffoldBackgroundColor: AppColors.background,

    textTheme: const TextTheme(
      displayLarge: AppTextStyles.displayLarge,
      displayMedium: AppTextStyles.displayMedium,
      headlineLarge: AppTextStyles.headlineLarge,
      headlineMedium: AppTextStyles.headlineMedium,
      titleLarge: AppTextStyles.titleLarge,
      titleMedium: AppTextStyles.titleMedium,
      titleSmall: AppTextStyles.titleSmall,
      bodyLarge: AppTextStyles.bodyLarge,
      bodyMedium: AppTextStyles.bodyMedium,
      bodySmall: AppTextStyles.bodySmall,
      labelLarge: AppTextStyles.labelLarge,
      labelMedium: AppTextStyles.labelMedium,
      labelSmall: AppTextStyles.labelSmall,
    ),

    appBarTheme: const AppBarTheme(
      elevation: 0,
      centerTitle: false,
      backgroundColor: AppColors.surface,
      foregroundColor: AppColors.textPrimary,
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.surface,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.spacing16,
        vertical: AppDimensions.spacing12,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
        borderSide: const BorderSide(color: AppColors.primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
        borderSide: const BorderSide(color: AppColors.error),
      ),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(0, AppDimensions.buttonHeight),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
        ),
        textStyle: AppTextStyles.labelLarge,
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(0, AppDimensions.buttonHeight),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
        ),
        textStyle: AppTextStyles.labelLarge,
      ),
    ),

    cardTheme: CardThemeData(
      elevation: 0,
      color: AppColors.surface,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
        side: const BorderSide(color: AppColors.border),
      ),
    ),

    dialogTheme: AppComponentThemes.dialog(
      _lightScheme,
      border: AppColors.border,
    ),
    snackBarTheme: AppComponentThemes.snackBar(_lightScheme),
    datePickerTheme: AppComponentThemes.datePicker(
      _lightScheme,
      border: AppColors.border,
    ),
    popupMenuTheme: AppComponentThemes.popupMenu(
      _lightScheme,
      border: AppColors.border,
    ),

    dividerTheme: const DividerThemeData(
      color: AppColors.border,
      thickness: 1,
      space: 1,
    ),
  );

  // ===========================================================================
  // DARK THEME
  // ===========================================================================
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    fontFamily: AppTextStyles.fontFamily,
    brightness: Brightness.dark,

    colorScheme: _darkScheme,

    scaffoldBackgroundColor: const Color(0xFF121212),

    textTheme: TextTheme(
      displayLarge: AppTextStyles.displayLarge.copyWith(
        color: AppColors.darkText,
      ),
      displayMedium: AppTextStyles.displayMedium.copyWith(
        color: AppColors.darkText,
      ),
      headlineLarge: AppTextStyles.headlineLarge.copyWith(
        color: AppColors.darkText,
      ),
      headlineMedium: AppTextStyles.headlineMedium.copyWith(
        color: AppColors.darkText,
      ),
      titleLarge: AppTextStyles.titleLarge.copyWith(color: AppColors.darkText),
      titleMedium: AppTextStyles.titleMedium.copyWith(
        color: AppColors.darkText,
      ),
      titleSmall: AppTextStyles.titleSmall.copyWith(
        color: AppColors.darkTextSecondary,
      ),
      bodyLarge: AppTextStyles.bodyLarge.copyWith(color: AppColors.darkText),
      bodyMedium: AppTextStyles.bodyMedium.copyWith(
        color: AppColors.darkTextSecondary,
      ),
      bodySmall: AppTextStyles.bodySmall.copyWith(
        color: AppColors.darkTextHint,
      ),
      labelLarge: AppTextStyles.labelLarge.copyWith(color: AppColors.darkText),
      labelMedium: AppTextStyles.labelMedium.copyWith(
        color: AppColors.darkTextSecondary,
      ),
      labelSmall: AppTextStyles.labelSmall.copyWith(
        color: AppColors.darkTextHint,
      ),
    ),

    appBarTheme: const AppBarTheme(
      elevation: 0,
      centerTitle: false,
      backgroundColor: Color(0xFF1E1E1E),
      foregroundColor: AppColors.darkText,
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.darkFieldBackground,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.spacing16,
        vertical: AppDimensions.spacing12,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
        borderSide: const BorderSide(color: AppColors.darkBorder),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
        borderSide: const BorderSide(color: AppColors.darkBorder),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
        borderSide: const BorderSide(
          color: AppColors.primaryContainer,
          width: 2,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
        borderSide: const BorderSide(color: AppColors.error),
      ),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(0, AppDimensions.buttonHeight),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
        ),
        textStyle: AppTextStyles.labelLarge,
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(0, AppDimensions.buttonHeight),
        foregroundColor: AppColors.primaryContainer,
        side: const BorderSide(color: AppColors.darkBorder),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
        ),
        textStyle: AppTextStyles.labelLarge,
      ),
    ),

    cardTheme: CardThemeData(
      elevation: 0,
      color: const Color(0xFF1E1E1E),
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
        side: const BorderSide(color: AppColors.darkBorder),
      ),
    ),

    dialogTheme: AppComponentThemes.dialog(
      _darkScheme,
      border: AppColors.darkBorder,
    ),
    snackBarTheme: AppComponentThemes.snackBar(_darkScheme),
    datePickerTheme: AppComponentThemes.datePicker(
      _darkScheme,
      border: AppColors.darkBorder,
    ),
    popupMenuTheme: AppComponentThemes.popupMenu(
      _darkScheme,
      border: AppColors.darkBorder,
    ),

    dividerTheme: const DividerThemeData(
      color: AppColors.darkBorder,
      thickness: 1,
      space: 1,
    ),
  );
}
