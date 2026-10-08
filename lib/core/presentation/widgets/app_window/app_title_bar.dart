import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';

import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_dimensions.dart';
import 'window_controls.dart';

class AppTitleBar extends StatelessWidget {
  final bool isDark;

  const AppTitleBar({super.key, this.isDark = false});

  @override
  Widget build(BuildContext context) {
    final isDarkMode =
        isDark || Theme.of(context).brightness == Brightness.dark;

    final textColor = isDarkMode ? AppColors.darkText : AppColors.textPrimary;
    final iconColor = isDarkMode
        ? AppColors.primaryContainer
        : AppColors.primary;

    return SizedBox(
      height: 40,
      child: Row(
        children: [
          Expanded(
            child: MoveWindow(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.spacing16,
                ),
                child: Row(
                  children: [
                    Icon(Icons.pets, size: 20, color: iconColor),
                    const SizedBox(width: 10),
                    Text(
                      'Dog Care & Monitoring System',
                      style: Theme.of(
                        context,
                      ).textTheme.titleSmall?.copyWith(color: textColor),
                    ),
                  ],
                ),
              ),
            ),
          ),
          WindowControls(isDark: isDarkMode),
        ],
      ),
    );
  }
}
