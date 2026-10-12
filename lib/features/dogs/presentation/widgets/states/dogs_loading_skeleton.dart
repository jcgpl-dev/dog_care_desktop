import 'package:dog_care_desktop/config/theme/app_dimensions.dart';
import 'package:flutter/material.dart';

/// Placeholder rows that match the table's rhythm, so the layout doesn't jump
/// when data arrives (a bare spinner makes it jump).
class DogsLoadingSkeleton extends StatelessWidget {
  const DogsLoadingSkeleton({super.key, this.rows = 8});

  final int rows;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bar = (isDark ? Colors.white : Colors.black).withValues(alpha: 0.07);

    return Semantics(
      label: 'Loading dogs',
      child: Column(
        children: [
          for (var i = 0; i < rows; i++)
            Padding(
              padding: const EdgeInsets.only(bottom: AppDimensions.spacing16),
              child: Row(
                children: [
                  _Bar(color: bar, width: 24),
                  const SizedBox(width: AppDimensions.spacing24),
                  _Bar(color: bar, width: 110),
                  const SizedBox(width: AppDimensions.spacing24),
                  Expanded(child: _Bar(color: bar)),
                  const SizedBox(width: AppDimensions.spacing24),
                  Expanded(child: _Bar(color: bar)),
                  const SizedBox(width: AppDimensions.spacing24),
                  _Bar(color: bar, width: 70),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _Bar extends StatelessWidget {
  const _Bar({required this.color, this.width});

  final Color color;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: 16,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
      ),
    );
  }
}
