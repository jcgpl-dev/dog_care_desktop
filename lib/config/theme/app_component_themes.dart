import 'package:flutter/material.dart';

import 'app_dimensions.dart';
import 'app_text_styles.dart';

abstract final class AppComponentThemes {
  static RoundedRectangleBorder _shape(double radius, [Color? border]) =>
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius),
        side: border == null ? BorderSide.none : BorderSide(color: border),
      );

  static DialogThemeData dialog(ColorScheme scheme, {required Color border}) {
    return DialogThemeData(
      backgroundColor: scheme.surface,
      surfaceTintColor: Colors.transparent,
      elevation: 8,
      shape: _shape(AppDimensions.radiusLarge, border),
      titleTextStyle: AppTextStyles.titleMedium.copyWith(
        fontWeight: FontWeight.bold,
        color: scheme.onSurface,
      ),
      contentTextStyle: AppTextStyles.bodyMedium.copyWith(
        color: scheme.onSurfaceVariant,
      ),
    );
  }

  static SnackBarThemeData snackBar(ColorScheme scheme) {
    return SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      backgroundColor: scheme.inverseSurface,
      contentTextStyle: AppTextStyles.bodyMedium.copyWith(
        color: scheme.onInverseSurface,
      ),
      actionTextColor: scheme.inversePrimary,
      elevation: 4,
      shape: _shape(AppDimensions.radiusSmall),
    );
  }

  static DatePickerThemeData datePicker(
    ColorScheme scheme, {
    required Color border,
  }) {
    return DatePickerThemeData(
      backgroundColor: scheme.surface,
      surfaceTintColor: Colors.transparent,
      elevation: 8,
      shape: _shape(AppDimensions.radiusLarge, border),
      headerBackgroundColor: scheme.primary,
      headerForegroundColor: scheme.onPrimary,
      dividerColor: border,
      todayForegroundColor: WidgetStatePropertyAll(scheme.primary),
      todayBorder: BorderSide(color: scheme.primary),
      cancelButtonStyle: TextButton.styleFrom(
        foregroundColor: scheme.onSurfaceVariant,
      ),
      confirmButtonStyle: TextButton.styleFrom(foregroundColor: scheme.primary),
    );
  }

  static PopupMenuThemeData popupMenu(
    ColorScheme scheme, {
    required Color border,
  }) {
    return PopupMenuThemeData(
      color: scheme.surface,
      surfaceTintColor: Colors.transparent,
      elevation: 6,
      shape: _shape(AppDimensions.radiusSmall, border),
      textStyle: AppTextStyles.bodyMedium.copyWith(color: scheme.onSurface),
    );
  }
}
