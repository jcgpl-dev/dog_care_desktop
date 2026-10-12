import 'dart:math' as math;

import 'package:dog_care_desktop/config/theme/app_colors.dart';
import 'package:dog_care_desktop/config/theme/app_dimensions.dart';
import 'package:dog_care_desktop/config/theme/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

enum _PaginationLayout { wide, medium, narrow }

class DogsPaginationBar extends StatelessWidget {
  const DogsPaginationBar({
    super.key,
    required this.page,
    required this.pageSize,
    required this.totalItems,
    required this.onPageChanged,
  });

  /// Zero-based.
  final int page;
  final int pageSize;
  final int totalItems;
  final ValueChanged<int> onPageChanged;

  _PaginationLayout _layoutFor(double width) {
    if (width >= 560) return _PaginationLayout.wide;
    if (width >= 380) return _PaginationLayout.medium;
    return _PaginationLayout.narrow;
  }

  @override
  Widget build(BuildContext context) {
    final pageCount = totalItems == 0 ? 1 : (totalItems / pageSize).ceil();
    final first = totalItems == 0 ? 0 : page * pageSize + 1;
    final last = totalItems == 0
        ? 0
        : math.min((page + 1) * pageSize, totalItems);
    final muted = AppTextStyles.bodyMedium.copyWith(
      color: AppColors.textSecondary,
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        final layout = _layoutFor(constraints.maxWidth);

        final summary = switch (layout) {
          _PaginationLayout.wide =>
            'Showing $first to $last of $totalItems entries',
          _PaginationLayout.medium => '$first–$last of $totalItems',
          _PaginationLayout.narrow => null,
        };

        final pageLabel = layout == _PaginationLayout.wide
            ? 'Page ${page + 1} of $pageCount'
            : '${page + 1} / $pageCount';

        return SizedBox(
          height: 56,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.spacing16,
            ),
            child: Row(
              mainAxisAlignment: summary == null
                  ? MainAxisAlignment.center
                  : MainAxisAlignment.start,
              children: [
                if (summary != null)
                  Expanded(
                    child: Text(
                      summary,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: muted,
                    ),
                  ),
                IconButton(
                  tooltip: 'Previous page',
                  onPressed: page > 0 ? () => onPageChanged(page - 1) : null,
                  icon: Icon(
                    PhosphorIcons.caretLeft(PhosphorIconsStyle.bold),
                    size: 16,
                  ),
                ),
                Text(pageLabel, maxLines: 1, style: muted),
                IconButton(
                  tooltip: 'Next page',
                  onPressed: page < pageCount - 1
                      ? () => onPageChanged(page + 1)
                      : null,
                  icon: Icon(
                    PhosphorIcons.caretRight(PhosphorIconsStyle.bold),
                    size: 16,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
