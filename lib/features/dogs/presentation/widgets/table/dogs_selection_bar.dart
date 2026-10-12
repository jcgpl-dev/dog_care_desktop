import 'package:dog_care_desktop/config/theme/app_colors.dart';
import 'package:dog_care_desktop/config/theme/app_dimensions.dart';
import 'package:dog_care_desktop/config/theme/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class DogsSelectionBar extends StatelessWidget {
  const DogsSelectionBar({
    super.key,
    required this.count,
    required this.onDelete,
    required this.onClear,
  });

  final int count;
  final VoidCallback onDelete;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Material(
      elevation: 6,
      color: isDark ? const Color(0xFF2D2D2D) : AppColors.textPrimary,
      borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.spacing20,
          vertical: AppDimensions.spacing12,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '$count selected',
              style: AppTextStyles.bodyMedium.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: AppDimensions.spacing24),
            ElevatedButton.icon(
              onPressed: onDelete,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.error,
                foregroundColor: Colors.white,
                minimumSize: const Size(0, 36),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    AppDimensions.radiusSmall,
                  ),
                ),
              ),

              icon: Icon(
                PhosphorIcons.trash(PhosphorIconsStyle.bold),
                size: 16,
              ),
              label: const Text('Delete selected'),
            ),
            const SizedBox(width: AppDimensions.spacing8),
            TextButton(
              onPressed: onClear,
              child: const Text(
                'Clear',
                style: TextStyle(color: Colors.white70),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
