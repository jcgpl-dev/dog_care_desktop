import 'package:flutter/material.dart';

import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_dimensions.dart';

enum AppTextFieldVariant { standard, dark }

class AppTextField extends StatelessWidget {
  final TextEditingController? controller;

  // Content
  final String label;
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

  const AppTextField({
    super.key,
    required this.label,
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
  });

  bool get isDark => variant == AppTextFieldVariant.dark;

  Color get _labelColor =>
      labelColor ??
      (isDark ? AppColors.darkTextSecondary : AppColors.textPrimary);

  Color get _textColor =>
      textColor ?? (isDark ? AppColors.darkText : AppColors.textPrimary);

  Color get _hintColor =>
      hintColor ?? (isDark ? AppColors.darkTextHint : AppColors.textSecondary);

  Color get _fillColor =>
      fillColor ?? (isDark ? AppColors.darkFieldBackground : AppColors.surface);

  Color get _prefixIconColor =>
      prefixIconColor ??
      (isDark ? AppColors.darkIcon : AppColors.textSecondary);

  Color get _suffixIconColor =>
      suffixIconColor ??
      (isDark ? AppColors.darkIcon : AppColors.textSecondary);

  Color get _borderColor =>
      borderColor ?? (isDark ? AppColors.darkBorder : AppColors.border);

  Color get _focusedBorderColor =>
      focusedBorderColor ??
      (isDark ? AppColors.primaryContainer : AppColors.primary);

  Color get _errorBorderColor => errorBorderColor ?? AppColors.error;

  Color get _disabledBorderColor =>
      disabledBorderColor ??
      (isDark ? AppColors.darkBorderDisabled : AppColors.borderDisabled);
  double get _borderRadius => borderRadius ?? AppDimensions.radiusSmall;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: textTheme.labelMedium?.copyWith(color: _labelColor)),

        const SizedBox(height: AppDimensions.spacing8),

        TextFormField(
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

          style: textTheme.bodyMedium?.copyWith(color: _textColor),

          decoration: InputDecoration(
            hintText: hint,
            errorText: errorText,

            hintStyle: textTheme.bodyMedium?.copyWith(color: _hintColor),

            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon,

            prefixIconColor: _prefixIconColor,
            suffixIconColor: _suffixIconColor,

            filled: true,
            fillColor: _fillColor,

            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.spacing16,
              vertical: AppDimensions.spacing12,
            ),

            border: _border(color: _borderColor),

            enabledBorder: _border(color: _borderColor),

            focusedBorder: _border(
              color: _focusedBorderColor,
              width: focusedBorderWidth,
            ),

            errorBorder: _border(color: _errorBorderColor),

            focusedErrorBorder: _border(
              color: _errorBorderColor,
              width: focusedBorderWidth,
            ),

            disabledBorder: _border(color: _disabledBorderColor),
          ),
        ),
      ],
    );
  }

  OutlineInputBorder _border({required Color color, double width = 1}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(_borderRadius),
      borderSide: BorderSide(color: color, width: width),
    );
  }
}
