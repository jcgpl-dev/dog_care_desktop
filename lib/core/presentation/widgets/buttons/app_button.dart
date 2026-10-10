import 'package:flutter/material.dart';

import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_dimensions.dart';
import '../../../../config/theme/app_text_styles.dart';

enum AppButtonVariant { primary, outlined, text }

class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final Widget? icon;
  final AppButtonVariant variant;

  // Appearance overrides
  final Color? backgroundColor;
  final Color? foregroundColor;
  final Color? borderColor;

  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.icon,
    this.variant = AppButtonVariant.primary,
    this.backgroundColor,
    this.foregroundColor,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    final effectiveBorderRadius = BorderRadius.circular(
      AppDimensions.radiusSmall,
    );
    final effectiveHeight = AppDimensions.buttonHeight;

    if (variant == AppButtonVariant.outlined) {
      return SizedBox(
        width: double.infinity,
        height: effectiveHeight,
        child: OutlinedButton.icon(
          style: OutlinedButton.styleFrom(
            foregroundColor:
                foregroundColor ??
                (isDarkMode ? AppColors.darkText : AppColors.textPrimary),
            side: BorderSide(
              color:
                  borderColor ??
                  (isDarkMode ? AppColors.darkBorder : AppColors.border),
              width: 1,
            ),
            shape: RoundedRectangleBorder(borderRadius: effectiveBorderRadius),
          ),
          onPressed: isLoading ? null : onPressed,
          icon: isLoading
              ? const SizedBox.shrink()
              : icon ?? const SizedBox.shrink(),
          label: isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(label, style: AppTextStyles.labelLarge),
        ),
      );
    }

    // Primary Filled Button
    return SizedBox(
      width: double.infinity,
      height: effectiveHeight,
      child: FilledButton.icon(
        style: ButtonStyle(
          backgroundColor: WidgetStatePropertyAll(
            backgroundColor ?? AppColors.primary,
          ),
          foregroundColor: WidgetStatePropertyAll(
            foregroundColor ?? Colors.white,
          ),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(borderRadius: effectiveBorderRadius),
          ),
        ),
        onPressed: isLoading ? null : onPressed,
        icon: isLoading
            ? const SizedBox.shrink()
            : icon ?? const SizedBox.shrink(),
        label: isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : Text(label, style: AppTextStyles.labelLarge),
      ),
    );
  }
}
