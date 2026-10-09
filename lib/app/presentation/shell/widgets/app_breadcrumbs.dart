import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../../config/theme/app_colors.dart';

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
    final location = GoRouterState.of(context).matchedLocation;
    final segments = location.split('/').where((s) => s.isNotEmpty).toList();

    if (segments.isEmpty) {
      return const Text(
        'Dashboard',
        style: TextStyle(fontWeight: FontWeight.bold),
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
          borderRadius: BorderRadius.circular(4),
          onTap: isLast ? null : () => context.go(targetPath),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
            child: Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: isLast ? FontWeight.bold : FontWeight.w500,
                color: isLast
                    ? Theme.of(context).textTheme.titleMedium?.color
                    : AppColors.primary,
              ),
            ),
          ),
        ),
      );

      if (!isLast) {
        breadcrumbs.add(
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: Icon(
              PhosphorIcons.caretRight(PhosphorIconsStyle.bold),
              size: 12,
              color: AppColors.textSecondary,
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
