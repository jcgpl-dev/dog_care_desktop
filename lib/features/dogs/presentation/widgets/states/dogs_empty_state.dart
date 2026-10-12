import 'package:dog_care_desktop/config/theme/app_colors.dart';
import 'package:dog_care_desktop/config/theme/app_dimensions.dart';
import 'package:dog_care_desktop/config/theme/app_text_styles.dart';
import 'package:dog_care_desktop/core/presentation/widgets/buttons/app_button.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

/// Two different situations, two different messages:
/// "nothing yet" (with a CTA) vs "nothing matches" (adjust your search).
class DogsEmptyState extends StatelessWidget {
  const DogsEmptyState({
    super.key,
    required this.isFiltering,
    required this.onRegister,
  });

  final bool isFiltering;
  final VoidCallback onRegister;

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
                  ? PhosphorIcons.magnifyingGlass(PhosphorIconsStyle.bold)
                  : PhosphorIcons.dog(PhosphorIconsStyle.bold),
              size: 48,
              color: AppColors.textDisabled,
            ),
            const SizedBox(height: AppDimensions.spacing12),
            Text(
              isFiltering ? 'No dogs match your search' : 'No dogs registered yet',
              style: AppTextStyles.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppDimensions.spacing8),
            Text(
              isFiltering
                  ? 'Try a different keyword or clear the sex filter.'
                  : 'Register the first dog to start building the record.',
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
                  label: 'Register Dog',
                  variant: AppButtonVariant.primary,
                  onPressed: onRegister,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
