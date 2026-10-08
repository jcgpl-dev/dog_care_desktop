// lib/app/presentation/shell/app_sidebar.dart
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../config/theme/app_colors.dart';
import '../../../config/theme/app_dimensions.dart';
import 'app_navigation_item.dart';
import 'cubit/sidebar_cubit.dart';

class AppSidebar extends StatefulWidget {
  const AppSidebar({super.key});

  @override
  State<AppSidebar> createState() => _AppSidebarState();
}

class _AppSidebarState extends State<AppSidebar> {
  bool _isServicesExpanded = true;

  static const _primaryItems = [
    AppNavigationItem(
      label: 'Dashboard',
      icon: Icons.grid_view_rounded,
      route: '/dashboard',
    ),
    AppNavigationItem(label: 'Dogs', icon: Icons.pets_outlined, route: '/dogs'),
    AppNavigationItem(
      label: 'Health Records',
      icon: Icons.favorite_border_rounded,
      route: '/health-records',
    ),
    AppNavigationItem(
      label: 'Services',
      icon: Icons.favorite_outline_rounded,
      children: [
        AppNavigationItem(
          label: 'Vaccinations',
          icon: Icons.vaccines_outlined,
          route: '/vaccinations',
        ),
        AppNavigationItem(
          label: 'Deworming',
          icon: Icons.link_outlined,
          route: '/deworming',
        ),
        AppNavigationItem(
          label: 'Treatments',
          icon: Icons.medical_services_outlined,
          route: '/treatments',
        ),
      ],
    ),
    AppNavigationItem(
      label: 'Appointments',
      icon: Icons.calendar_today_outlined,
      route: '/appointments',
    ),
    AppNavigationItem(
      label: 'Reports',
      icon: Icons.description_outlined,
      route: '/reports',
    ),
    AppNavigationItem(
      label: 'Alerts',
      icon: Icons.notifications_none_outlined,
      route: '/alerts',
    ),
  ];

  static const _adminItems = [
    AppNavigationItem(
      label: 'Manage Users',
      icon: Icons.people_outline_rounded,
      route: '/manage-users',
    ),
    AppNavigationItem(
      label: 'Settings',
      icon: Icons.settings_outlined,
      route: '/settings',
    ),
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
                    for (final item in _primaryItems) ...[
                      if (item.hasChildren)
                        _buildExpandableGroup(item, isCollapsed, isDarkMode)
                      else
                        _SidebarItem(item: item, isCollapsed: isCollapsed),
                    ],
                    const SizedBox(height: AppDimensions.spacing12),
                    Divider(
                      color: isDarkMode
                          ? AppColors.darkBorder
                          : AppColors.border,
                    ),
                    const SizedBox(height: AppDimensions.spacing12),
                    if (!isCollapsed)
                      Padding(
                        padding: const EdgeInsets.only(
                          left: AppDimensions.spacing12,
                          bottom: AppDimensions.spacing8,
                        ),
                        child: Text(
                          'ADMIN',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.1,
                          ),
                        ),
                      ),
                    for (final item in _adminItems)
                      _SidebarItem(item: item, isCollapsed: isCollapsed),
                  ],
                ),
              ),
              _buildBottomProfileCard(context, isCollapsed, isDarkMode),
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

  Widget _buildExpandableGroup(
    AppNavigationItem parent,
    bool isCollapsed,
    bool isDarkMode,
  ) {
    if (isCollapsed) {
      return Column(
        children: [
          _SidebarItem(item: parent, isCollapsed: true),
          for (final child in parent.children!)
            _SidebarItem(item: child, isCollapsed: true, isSubItem: true),
        ],
      );
    }

    return Column(
      children: [
        _SidebarItem(
          item: parent,
          isCollapsed: false,
          isExpanded: _isServicesExpanded,
          onTap: () {
            setState(() {
              _isServicesExpanded = !_isServicesExpanded;
            });
          },
        ),
        if (_isServicesExpanded)
          Padding(
            padding: const EdgeInsets.only(left: AppDimensions.spacing12),
            child: Column(
              children: [
                for (final child in parent.children!)
                  _SidebarItem(
                    item: child,
                    isCollapsed: false,
                    isSubItem: true,
                  ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildBottomProfileCard(
    BuildContext context,
    bool isCollapsed,
    bool isDarkMode,
  ) {
    final cardBg = isDarkMode
        ? AppColors.primary.withOpacity(0.15)
        : AppColors.primaryContainer.withOpacity(0.5);

    return Container(
      margin: const EdgeInsets.all(AppDimensions.spacing12),
      padding: EdgeInsets.symmetric(
        horizontal: isCollapsed ? 0 : AppDimensions.spacing12,
        vertical: AppDimensions.spacing8,
      ),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
      ),
      child: Row(
        mainAxisAlignment: isCollapsed
            ? MainAxisAlignment.center
            : MainAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: AppColors.primary,
            child: const Text(
              'A',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
          if (!isCollapsed) ...[
            const SizedBox(width: AppDimensions.spacing12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Admin User',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Administrator',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(fontSize: 11),
                  ),
                ],
              ),
            ),
            const Icon(Icons.keyboard_arrow_down, size: 18),
          ],
        ],
      ),
    );
  }
}

class _SidebarItem extends StatelessWidget {
  final AppNavigationItem item;
  final bool isCollapsed;
  final bool isSubItem;
  final bool? isExpanded;
  final VoidCallback? onTap;

  const _SidebarItem({
    required this.item,
    required this.isCollapsed,
    this.isSubItem = false,
    this.isExpanded,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    // Resolve current URI to highlight active nav selection
    final currentPath = GoRouterState.of(context).matchedLocation;
    final isSelected = item.route != null && currentPath == item.route;

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
          onTap: () {
            if (onTap != null) {
              onTap!();
            } else if (item.route != null) {
              context.go(item.route!);
            }
          },
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
                        size: isSubItem ? 18 : 20,
                        color: isSelected
                            ? activeItemColor
                            : unselectedIconColor,
                      ),
                    ),
                  ),
                  if (!isCollapsed) ...[
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
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    if (isExpanded != null)
                      Padding(
                        padding: const EdgeInsets.only(
                          right: AppDimensions.spacing12,
                        ),
                        child: Icon(
                          isExpanded!
                              ? Icons.keyboard_arrow_up
                              : Icons.keyboard_arrow_down,
                          size: 18,
                          color: unselectedIconColor,
                        ),
                      ),
                  ],
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
