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

    return Container(
      height: DogsTableLayout.headerHeight,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
        color: isDark
            ? AppColors.primary.withValues(alpha: 0.07)
            : AppColors.primary.withValues(alpha: 0.07),
        // color: isDark
        //     ? const Color(0xFF1E1E1E)
        //     : AppColors.surfaceVariant.withValues(alpha: 0.6),
        // border: Border(
        //   bottom: BorderSide(
        //     color: isDark ? AppColors.darkBorder : AppColors.border,
        //   ),
        // ),
      ),
      child: Row(
        children: [
          SizedBox(
            width: DogsTableLayout.checkboxWidth,
            child: Center(
              child: Checkbox(
                tristate: true,
                value: selectionState,
                onChanged: (_) => onToggleSelectAll(),
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
          const SizedBox(width: DogsTableLayout.actionsWidth),
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
    final label = Text(
      column.label,
      overflow: TextOverflow.ellipsis,
      style: AppTextStyles.labelMedium.copyWith(
        fontWeight: FontWeight.w600,
        color: isActive ? AppColors.primary : AppColors.textSecondary,
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
