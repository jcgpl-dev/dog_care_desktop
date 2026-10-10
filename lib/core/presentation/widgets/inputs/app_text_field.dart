import 'package:flutter/material.dart';

import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_dimensions.dart';

enum AppTextFieldVariant { standard, dark }

class AppTextField extends StatelessWidget {
  final TextEditingController? controller;

  final String? label;
  final String? hint;
  final String? errorText;

  // Input behavior
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final bool obscureText;
  final bool enabled;
  final bool readOnly;
  final bool autofocus;

  final int? maxLines;
  final int? maxLength;

  // Icons
  final Widget? prefixIcon;
  final Widget? suffixIcon;

  // Validation / callbacks
  final String? Function(String?)? validator;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onTap;
  final ValueChanged<String>? onSubmitted;
  final FocusNode? focusNode;

  // Appearance
  final AppTextFieldVariant variant;

  final Color? labelColor;
  final Color? textColor;
  final Color? hintColor;

  final Color? fillColor;

  final Color? prefixIconColor;
  final Color? suffixIconColor;

  final Color? borderColor;
  final Color? focusedBorderColor;
  final Color? errorBorderColor;
  final Color? disabledBorderColor;

  final double? borderRadius;
  final double focusedBorderWidth;
  final EdgeInsetsGeometry? contentPadding;

  const AppTextField({
    super.key,
    this.label,
    this.controller,
    this.hint,
    this.errorText,
    this.keyboardType,
    this.textInputAction,
    this.obscureText = false,
    this.enabled = true,
    this.readOnly = false,
    this.autofocus = false,
    this.maxLines = 1,
    this.maxLength,
    this.prefixIcon,
    this.suffixIcon,
    this.validator,
    this.onChanged,
    this.onTap,
    this.onSubmitted,
    this.focusNode,
    this.variant = AppTextFieldVariant.standard,

    // Appearance overrides
    this.labelColor,
    this.textColor,
    this.hintColor,
    this.fillColor,
    this.prefixIconColor,
    this.suffixIconColor,
    this.borderColor,
    this.focusedBorderColor,
    this.errorBorderColor,
    this.disabledBorderColor,
    this.borderRadius,
    this.focusedBorderWidth = 2,
    this.contentPadding,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final isDarkMode =
        variant == AppTextFieldVariant.dark ||
        Theme.of(context).brightness == Brightness.dark;

    // Live theme-aware color resolvers
    final effectiveLabelColor =
        labelColor ??
        (isDarkMode ? AppColors.darkTextSecondary : AppColors.textPrimary);

    final effectiveTextColor =
        textColor ?? (isDarkMode ? AppColors.darkText : AppColors.textPrimary);

    final effectiveHintColor =
        hintColor ??
        (isDarkMode ? AppColors.darkTextHint : AppColors.textSecondary);

    final effectiveFillColor =
        fillColor ??
        (isDarkMode ? AppColors.darkFieldBackground : AppColors.surface);

    final effectivePrefixIconColor =
        prefixIconColor ??
        (isDarkMode ? AppColors.darkIcon : AppColors.textSecondary);

    final effectiveSuffixIconColor =
        suffixIconColor ??
        (isDarkMode ? AppColors.darkIcon : AppColors.textSecondary);

    final effectiveBorderColor =
        borderColor ?? (isDarkMode ? AppColors.darkBorder : AppColors.border);

    final effectiveFocusedBorderColor =
        focusedBorderColor ??
        (isDarkMode ? AppColors.primaryContainer : AppColors.primary);

    final effectiveErrorBorderColor = errorBorderColor ?? AppColors.error;

    final effectiveDisabledBorderColor =
        disabledBorderColor ??
        (isDarkMode ? AppColors.darkBorderDisabled : AppColors.borderDisabled);

    final effectiveBorderRadius = borderRadius ?? AppDimensions.radiusSmall;

    OutlineInputBorder getBorder(Color color, {double width = 1}) {
      return OutlineInputBorder(
        borderRadius: BorderRadius.circular(effectiveBorderRadius),
        borderSide: BorderSide(color: color, width: width),
      );
    }

    final fieldWidget = TextFormField(
      controller: controller,
      focusNode: focusNode,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      obscureText: obscureText,
      enabled: enabled,
      readOnly: readOnly,
      autofocus: autofocus,
      maxLines: obscureText ? 1 : maxLines,
      maxLength: maxLength,
      validator: validator,
      onChanged: onChanged,
      onTap: onTap,
      onFieldSubmitted: onSubmitted,
      style: textTheme.bodyMedium?.copyWith(color: effectiveTextColor),
      decoration: InputDecoration(
        hintText: hint,
        errorText: errorText,
        hintStyle: textTheme.bodyMedium?.copyWith(color: effectiveHintColor),
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        prefixIconColor: effectivePrefixIconColor,
        suffixIconColor: effectiveSuffixIconColor,
        filled: true,
        fillColor: effectiveFillColor,
        contentPadding:
            contentPadding ??
            const EdgeInsets.symmetric(
              horizontal: AppDimensions.spacing16,
              vertical: AppDimensions.spacing12,
            ),
        border: getBorder(effectiveBorderColor),
        enabledBorder: getBorder(effectiveBorderColor),
        focusedBorder: getBorder(
          effectiveFocusedBorderColor,
          width: focusedBorderWidth,
        ),
        errorBorder: getBorder(effectiveErrorBorderColor),
        focusedErrorBorder: getBorder(
          effectiveErrorBorderColor,
          width: focusedBorderWidth,
        ),
        disabledBorder: getBorder(effectiveDisabledBorderColor),
      ),
    );

    if (label == null || label!.isEmpty) {
      return fieldWidget;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label!,
          style: textTheme.labelMedium?.copyWith(color: effectiveLabelColor),
        ),
        const SizedBox(height: AppDimensions.spacing8),
        fieldWidget,
      ],
    );
  }
}
