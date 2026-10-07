import 'package:flutter/material.dart';

import '../../../config/theme/app_colors.dart';
import '../../../config/theme/app_dimensions.dart';
import 'app_navigation_item.dart';

class AppSidebar extends StatelessWidget {
  const AppSidebar({super.key});

  static const _items = [
    AppNavigationItem(
      label: 'Dashboard',
      icon: Icons.dashboard_outlined,
      route: '/dashboard',
    ),
    AppNavigationItem(label: 'Dogs', icon: Icons.pets_outlined, route: '/dogs'),
    AppNavigationItem(
      label: 'Owners',
      icon: Icons.person_outline,
      route: '/owners',
    ),
    AppNavigationItem(
      label: 'Appointments',
      icon: Icons.calendar_month_outlined,
      route: '/appointments',
    ),
    AppNavigationItem(
      label: 'Vaccinations',
      icon: Icons.vaccines_outlined,
      route: '/vaccinations',
    ),
    AppNavigationItem(
      label: 'Health Records',
      icon: Icons.medical_information_outlined,
      route: '/health-records',
    ),
    AppNavigationItem(
      label: 'Reports',
      icon: Icons.bar_chart_outlined,
      route: '/reports',
    ),
    AppNavigationItem(label: 'GIS', icon: Icons.map_outlined, route: '/gis'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppDimensions.sidebarWidth,
      color: AppColors.surface,
      child: Column(
        children: [
          _buildHeader(context),
          const Divider(height: 1),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.spacing12,
                vertical: AppDimensions.spacing16,
              ),
              children: [for (final item in _items) _SidebarItem(item: item)],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return SizedBox(
      height: 72,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.spacing16,
        ),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: AppColors.primaryContainer,
                borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
              ),
              child: const Icon(Icons.pets, color: AppColors.primary),
            ),
            const SizedBox(width: AppDimensions.spacing12),
            Expanded(
              child: Text(
                'Dog Care',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SidebarItem extends StatelessWidget {
  final AppNavigationItem item;

  const _SidebarItem({required this.item});

  @override
  Widget build(BuildContext context) {
    // We'll replace this with go_router's current-route
    // detection once routing is connected.
    final isSelected = item.route == '/dashboard';

    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimensions.spacing4),
      child: Material(
        color: isSelected ? AppColors.primaryContainer : Colors.transparent,
        borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
        child: InkWell(
          borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
          onTap: () {
            // Routing will be connected in the next step.
          },
          child: SizedBox(
            height: 44,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.spacing12,
              ),
              child: Row(
                children: [
                  Icon(
                    item.icon,
                    size: 20,
                    color: isSelected
                        ? AppColors.primary
                        : AppColors.textSecondary,
                  ),
                  const SizedBox(width: AppDimensions.spacing12),
                  Text(
                    item.label,
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: isSelected
                          ? AppColors.primary
                          : AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
