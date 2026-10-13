import 'package:dog_care_desktop/config/theme/app_colors.dart';
import 'package:dog_care_desktop/config/theme/app_dimensions.dart';
import 'package:flutter/material.dart';

class DogsTableHeaderCheckbox extends StatelessWidget {
  const DogsTableHeaderCheckbox({
    super.key,
    required this.isAllSelected,
    required this.isPartiallySelected,
    required this.onChanged,
  });

  final bool isAllSelected;
  final bool isPartiallySelected;
  final ValueChanged<bool?> onChanged;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Muted border colors specifically for header neutrality
    final mutedBorderColor = isDark
        ? AppColors.darkBorder.withValues(alpha: 0.4)
        : AppColors.border.withValues(alpha: 0.6);

    final hoverBorderColor = isDark
        ? AppColors.darkTextSecondary
        : AppColors.textSecondary;

    return Theme(
      data: Theme.of(context).copyWith(
        checkboxTheme: CheckboxThemeData(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusSmall - 2),
          ),
          // Clean border resolution across interactive states
          side: WidgetStateBorderSide.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return BorderSide.none;
            }
            if (states.contains(WidgetState.hovered)) {
              return BorderSide(color: hoverBorderColor, width: 1.5);
            }
            // Muted, non-distracting default state
            return BorderSide(color: mutedBorderColor, width: 1.2);
          }),
          fillColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return AppColors.primary;
            }
            return Colors.transparent;
          }),
          checkColor: const WidgetStatePropertyAll(Colors.white),
        ),
      ),
      child: Checkbox(
        // Tristate enables the indeterminate / partial selection state (-)
        tristate: true,
        value: isAllSelected ? true : (isPartiallySelected ? null : false),
        onChanged: (value) => onChanged(value ?? false),
      ),
    );
  }
}
