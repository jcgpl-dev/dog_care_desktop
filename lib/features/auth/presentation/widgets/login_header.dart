import 'package:flutter/material.dart';

import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_dimensions.dart';

class LoginHeader extends StatelessWidget {
  const LoginHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      children: [
        Container(
          width: AppDimensions.loginLogoSize,
          height: AppDimensions.loginLogoSize,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(AppDimensions.loginLogoRadius),
          ),
          child: const Icon(
            Icons.pets,
            color: AppColors.darkText,
            size: AppDimensions.loginLogoIconSize,
          ),
        ),

        const SizedBox(height: AppDimensions.spacing16),

        Text(
          'Dog Care',
          style: textTheme.displayMedium?.copyWith(color: AppColors.darkText),
        ),

        Text(
          'Dog Care & Monitoring System',
          style: textTheme.bodyMedium?.copyWith(
            color: AppColors.darkTextSecondary,
          ),
        ),
      ],
    );
  }
}
