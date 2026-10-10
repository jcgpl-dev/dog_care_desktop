import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../../config/theme/app_dimensions.dart';
import 'app_text_field.dart';

class AppSearchField extends StatelessWidget {
  final TextEditingController? controller;
  final String hint;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onClear;
  final AppTextFieldVariant variant;

  const AppSearchField({
    super.key,
    this.controller,
    this.hint = 'Search...',
    this.onChanged,
    this.onClear,
    this.variant = AppTextFieldVariant.standard,
  });

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      controller: controller,
      hint: hint,
      variant: variant,
      borderRadius: AppDimensions.radiusSmall,

      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.spacing16,
        vertical: 0,
      ),
      prefixIcon: Icon(
        PhosphorIcons.magnifyingGlass(PhosphorIconsStyle.bold),
        size: AppDimensions.spacing20,
      ),
      onChanged: onChanged,
    );
  }
}
