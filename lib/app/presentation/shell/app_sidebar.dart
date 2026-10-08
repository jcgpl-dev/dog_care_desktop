import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../config/theme/app_colors.dart';
import '../../../config/theme/app_dimensions.dart';
import 'app_navigation_item.dart';
import 'cubit/sidebar_cubit.dart';

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
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return BlocBuilder<SidebarCubit, bool>(
      builder: (context, isCollapsed) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          width: isCollapsed
              ? AppDimensions.collapsedSidebarWidth
              : AppDimensions.sidebarWidth,
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            border: Border(
              right: BorderSide(
                color: isDarkMode ? AppColors.darkBorder : AppColors.border,
              ),
            ),
          ),
          child: Column(
            children: [
              _buildHeader(context, isDarkMode, isCollapsed),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimensions.spacing12,
                    vertical: AppDimensions.spacing16,
                  ),
                  children: [
                    for (final item in _items)
                      _SidebarItem(item: item, isCollapsed: isCollapsed),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context, bool isDarkMode, bool isCollapsed) {
    return Container(
      height: AppDimensions.sidebarHeaderHeight,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: isDarkMode ? AppColors.darkBorder : AppColors.border,
          ),
        ),
      ),
      child: MoveWindow(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.spacing12,
          ),
          child: Row(
            children: [
              SizedBox(
                width: 44,
                height: 44,
                child: Center(
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(
                        AppDimensions.radiusSmall,
                      ),
                    ),
                    child: Icon(
                      Icons.pets,
                      size: 18,
                      color: Theme.of(context).colorScheme.surface,
                    ),
                  ),
                ),
              ),

              if (!isCollapsed) ...[
                const SizedBox(width: AppDimensions.spacing8),
                Expanded(
                  child: Text(
                    'Dog Care',
                    maxLines: 1,
                    overflow: TextOverflow.clip,
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _SidebarItem extends StatelessWidget {
  final AppNavigationItem item;
  final bool isCollapsed;

  const _SidebarItem({required this.item, required this.isCollapsed});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final isSelected = item.route == '/dashboard';

    final activeBgColor = isDarkMode
        ? AppColors.primary.withOpacity(0.18)
        : AppColors.primaryContainer;
    final activeItemColor = isDarkMode
        ? AppColors.primaryContainer
        : AppColors.primary;
    final unselectedIconColor = isDarkMode
        ? AppColors.darkTextSecondary
        : AppColors.textSecondary;

    Widget itemTile = Padding(
      padding: const EdgeInsets.only(bottom: AppDimensions.spacing4),
      child: Material(
        color: isSelected ? activeBgColor : Colors.transparent,
        borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
        child: InkWell(
          borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
          onTap: () {},
          child: SizedBox(
            height: 40,
            child: ClipRect(
              child: Row(
                children: [
                  SizedBox(
                    width: 44,
                    height: 40,
                    child: Center(
                      child: Icon(
                        item.icon,
                        size: 20,
                        color: isSelected
                            ? activeItemColor
                            : unselectedIconColor,
                      ),
                    ),
                  ),

                  if (!isCollapsed)
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(
                          right: AppDimensions.spacing8,
                        ),
                        child: Text(
                          item.label,
                          maxLines: 1,
                          overflow: TextOverflow.clip,
                          style: theme.textTheme.labelLarge?.copyWith(
                            color: isSelected
                                ? activeItemColor
                                : theme.textTheme.bodyMedium?.color,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    if (isCollapsed) {
      return Tooltip(
        message: item.label,
        preferBelow: false,
        verticalOffset: 0,
        child: itemTile,
      );
    }

    return itemTile;
  }
}
