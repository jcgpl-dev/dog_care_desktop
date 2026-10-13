import 'package:dog_care_desktop/config/theme/app_colors.dart';
import 'package:dog_care_desktop/config/theme/app_dimensions.dart';
import 'package:dog_care_desktop/config/theme/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../models/dogs_query.dart';
import 'dogs_table_columns.dart';

class DogsTableHeader extends StatelessWidget {
  const DogsTableHeader({
    super.key,
    required this.selectionState,
    required this.sortField,
    required this.ascending,
    required this.onSort,
    required this.onToggleSelectAll,
  });

  /// true = all rows on page selected, null = some, false = none.
  final bool? selectionState;
  final DogSortField sortField;
  final bool ascending;
  final ValueChanged<DogSortField> onSort;
  final VoidCallback onToggleSelectAll;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Muted border colors specifically for the table header neutrality
    final mutedBorderColor = isDark
        ? AppColors.darkBorder.withValues(alpha: 0.4)
        : AppColors.border.withValues(alpha: 0.6);

    final hoverBorderColor = isDark
        ? AppColors.darkTextSecondary
        : AppColors.textSecondary;

    final textColor = isDark
        ? AppColors.darkTextSecondary
        : AppColors.textPrimary;

    return Container(
      height: DogsTableLayout.headerHeight,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
        color: AppColors.primary.withValues(alpha: 0.07),
      ),
      child: Row(
        children: [
          SizedBox(
            width: DogsTableLayout.checkboxWidth,
            child: Center(
              child: Theme(
                data: Theme.of(context).copyWith(
                  checkboxTheme: CheckboxThemeData(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        AppDimensions.radiusSmall - 2,
                      ),
                    ),
                    side: WidgetStateBorderSide.resolveWith((states) {
                      if (states.contains(WidgetState.selected)) {
                        return BorderSide.none;
                      }
                      if (states.contains(WidgetState.hovered)) {
                        return BorderSide(color: hoverBorderColor, width: 1.5);
                      }
                      // Muted, non-distracting default border for headers
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
                  tristate: true,
                  value: selectionState,
                  onChanged: (_) => onToggleSelectAll(),
                ),
              ),
            ),
          ),
          for (final column in DogsTableColumn.values)
            Expanded(
              flex: column.flex,
              child: _HeaderCell(
                column: column,
                isActive: column.sortField == sortField,
                ascending: ascending,
                onSort: onSort,
              ),
            ),
          SizedBox(
            width: DogsTableLayout.actionsWidth,
            child: Center(
              child: Text(
                'Actions',
                style: AppTextStyles.labelMedium.copyWith(
                  fontWeight: FontWeight.w600,
                  color: textColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HeaderCell extends StatelessWidget {
  const _HeaderCell({
    required this.column,
    required this.isActive,
    required this.ascending,
    required this.onSort,
  });

  final DogsTableColumn column;
  final bool isActive;
  final bool ascending;
  final ValueChanged<DogSortField> onSort;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark
        ? AppColors.darkTextSecondary
        : AppColors.textPrimary;
    final label = Text(
      column.label,
      overflow: TextOverflow.ellipsis,
      style: AppTextStyles.labelMedium.copyWith(
        fontWeight: FontWeight.w600,
        color: isActive ? AppColors.primary : textColor,
      ),
    );

    final sortField = column.sortField;
    if (sortField == null) {
      return Padding(padding: const EdgeInsets.only(right: 12), child: label);
    }

    return Tooltip(
      message: 'Sort by ${column.label.toLowerCase()}',
      child: InkWell(
        onTap: () => onSort(sortField),
        child: Padding(
          padding: const EdgeInsets.only(right: 12),
          child: Row(
            children: [
              Flexible(child: label),
              if (isActive) ...[
                const SizedBox(width: 4),
                Icon(
                  ascending
                      ? PhosphorIcons.arrowUp(PhosphorIconsStyle.bold)
                      : PhosphorIcons.arrowDown(PhosphorIconsStyle.bold),
                  size: 14,
                  color: AppColors.primary,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
