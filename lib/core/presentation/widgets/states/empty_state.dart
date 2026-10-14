import 'package:dog_care_desktop/config/theme/app_colors.dart';
import 'package:dog_care_desktop/config/theme/app_dimensions.dart';
import 'package:dog_care_desktop/config/theme/app_text_styles.dart';
import 'package:dog_care_desktop/core/presentation/widgets/buttons/app_button.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key,
    required this.isFiltering,
    required this.onActionPressed,
    this.title = 'No records registered yet',
    this.filteredTitle = 'No records match your search',
    this.subtitle = 'Register the first record to start building data.',
    this.filteredSubtitle = 'Try a different keyword or clear active filters.',
    this.actionLabel = 'Add New Record',
    this.icon = PhosphorIconsStyle.bold,
  });

  final bool isFiltering;
  final VoidCallback onActionPressed;
  final String title;
  final String filteredTitle;
  final String subtitle;
  final String filteredSubtitle;
  final String actionLabel;
  final PhosphorIconsStyle icon;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 360),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isFiltering
                  ? PhosphorIcons.magnifyingGlass(icon)
                  : PhosphorIcons.folderOpen(icon),
              size: 48,
              color: AppColors.textDisabled,
            ),
            const SizedBox(height: AppDimensions.spacing12),
            Text(
              isFiltering ? filteredTitle : title,
              style: AppTextStyles.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppDimensions.spacing8),
            Text(
              isFiltering ? filteredSubtitle : subtitle,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            if (!isFiltering) ...[
              const SizedBox(height: AppDimensions.spacing20),
              SizedBox(
                width: 180,
                child: AppButton(
                  label: actionLabel,
                  variant: AppButtonVariant.primary,
                  onPressed: onActionPressed,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
