import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_dimensions.dart';
import '../../../../config/theme/app_text_styles.dart';

class AppBreadcrumbs extends StatelessWidget {
  const AppBreadcrumbs({super.key});

  static const Map<String, String> _pathLabels = {
    'dashboard': 'Dashboard',
    'dogs': 'Dogs',
    'owners': 'Owners',
    'health-records': 'Health Records',
    'services': 'Services',
    'vaccinations': 'Vaccinations',
    'deworming': 'Deworming',
    'treatments': 'Treatments',
    'appointments': 'Appointments',
    'reports': 'Reports',
    'alerts': 'Alerts',
    'manage-users': 'User Management',
    'settings': 'Settings',
  };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final location = GoRouterState.of(context).matchedLocation;
    final segments = location.split('/').where((s) => s.isNotEmpty).toList();

    if (segments.isEmpty) {
      return Text(
        'Dashboard',
        style: AppTextStyles.titleMedium.copyWith(
          color: isDark ? AppColors.darkText : AppColors.textPrimary,
        ),
      );
    }

    final List<Widget> breadcrumbs = [];
    String accumulatedPath = '';

    for (int i = 0; i < segments.length; i++) {
      final segment = segments[i];
      accumulatedPath += '/$segment';
      final targetPath = accumulatedPath;
      final isLast = i == segments.length - 1;
      final label = _pathLabels[segment] ?? _capitalize(segment);

      breadcrumbs.add(
        InkWell(
          borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
          onTap: isLast ? null : () => context.go(targetPath),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.spacing4,
              vertical: AppDimensions.spacing2,
            ),
            child: Text(
              label,
              style: isLast
                  ? AppTextStyles.titleMedium.copyWith(
                      color: isDark
                          ? AppColors.darkText
                          : AppColors.textPrimary,
                    )
                  : AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
            ),
          ),
        ),
      );

      if (!isLast) {
        breadcrumbs.add(
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.spacing2,
            ),
            child: Icon(
              PhosphorIcons.caretRight(PhosphorIconsStyle.bold),
              size: AppDimensions.spacing12,
              color: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.textSecondary,
            ),
          ),
        );
      }
    }

    return Row(mainAxisSize: MainAxisSize.min, children: breadcrumbs);
  }

  String _capitalize(String str) {
    if (str.isEmpty) return str;
    return str[0].toUpperCase() + str.substring(1);
  }
}
