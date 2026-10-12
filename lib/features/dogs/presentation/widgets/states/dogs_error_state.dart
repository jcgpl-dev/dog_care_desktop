import 'package:dog_care_desktop/config/theme/app_colors.dart';
import 'package:dog_care_desktop/config/theme/app_dimensions.dart';
import 'package:dog_care_desktop/config/theme/app_text_styles.dart';
import 'package:dog_care_desktop/core/presentation/widgets/buttons/app_button.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class DogsErrorState extends StatelessWidget {
  const DogsErrorState({super.key, required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 380),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              PhosphorIcons.warningCircle(PhosphorIconsStyle.bold),
              size: 48,
              color: AppColors.error,
            ),
            const SizedBox(height: AppDimensions.spacing12),
            Text("Couldn't load dogs", style: AppTextStyles.titleMedium),
            const SizedBox(height: AppDimensions.spacing8),
            Text(
              message,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppDimensions.spacing20),
            SizedBox(
              width: 140,
              child: AppButton(
                label: 'Try again',
                variant: AppButtonVariant.outlined,
                onPressed: onRetry,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
