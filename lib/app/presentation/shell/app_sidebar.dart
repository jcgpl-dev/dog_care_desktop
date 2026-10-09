import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

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

  static final _primaryItems = [
    AppNavigationItem(
      label: 'Dashboard',
      icon: Icon(PhosphorIcons.squaresFour(PhosphorIconsStyle.bold), size: 20),
      route: '/dashboard',
    ),
    AppNavigationItem(
      label: 'Dogs',
      icon: Icon(PhosphorIcons.dog(PhosphorIconsStyle.bold), size: 20),
      route: '/dogs',
    ),
    AppNavigationItem(
      label: 'Owners',
      icon: Icon(PhosphorIcons.user(PhosphorIconsStyle.bold), size: 20),
      route: '/owners',
    ),
    AppNavigationItem(
      label: 'Health Records',
      icon: Icon(PhosphorIcons.heartbeat(PhosphorIconsStyle.bold), size: 20),
      route: '/health-records',
    ),
    AppNavigationItem(
      label: 'Services',
      icon: Icon(PhosphorIcons.firstAid(PhosphorIconsStyle.bold), size: 20),
      route: '/services',
      children: [
        AppNavigationItem(
          label: 'Vaccinations',
          icon: Icon(PhosphorIcons.syringe(PhosphorIconsStyle.bold), size: 18),
          route: '/vaccinations',
        ),
        AppNavigationItem(
          label: 'Deworming',
          icon: Icon(PhosphorIcons.pill(PhosphorIconsStyle.bold), size: 18),
          route: '/deworming',
        ),
        AppNavigationItem(
          label: 'Treatments',
          icon: Icon(
            PhosphorIcons.stethoscope(PhosphorIconsStyle.bold),
            size: 18,
          ),
          route: '/treatments',
        ),
      ],
    ),
    AppNavigationItem(
      label: 'Appointments',
      icon: Icon(
        PhosphorIcons.calendarBlank(PhosphorIconsStyle.bold),
        size: 20,
      ),
      route: '/appointments',
    ),
    AppNavigationItem(
      label: 'Reports',
      icon: Icon(PhosphorIcons.fileText(PhosphorIconsStyle.bold), size: 20),
      route: '/reports',
    ),
    AppNavigationItem(
      label: 'Alerts',
      icon: Icon(PhosphorIcons.bell(PhosphorIconsStyle.bold), size: 20),
      route: '/alerts',
    ),
  ];

  static final _adminItems = [
    AppNavigationItem(
      label: 'Manage Users',
      icon: Icon(PhosphorIcons.users(PhosphorIconsStyle.bold), size: 20),
      route: '/manage-users',
    ),
    AppNavigationItem(
      label: 'Settings',
      icon: Icon(PhosphorIcons.gear(PhosphorIconsStyle.bold), size: 20),
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
                      PhosphorIcons.pawPrint(PhosphorIconsStyle.fill),
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
          onChevronTap: () {
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
}

class _SidebarItem extends StatelessWidget {
  final AppNavigationItem item;
  final bool isCollapsed;
  final bool isSubItem;
  final bool? isExpanded;
  final VoidCallback? onTap;
  final VoidCallback? onChevronTap;

  const _SidebarItem({
    required this.item,
    required this.isCollapsed,
    this.isSubItem = false,
    this.isExpanded,
    this.onTap,
    this.onChevronTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

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
                      // Wrap item.icon in IconTheme to apply active/unselected color dynamically
                      child: IconTheme(
                        data: IconThemeData(
                          color: isSelected
                              ? activeItemColor
                              : unselectedIconColor,
                        ),
                        child: item.icon, // 👈 Directly renders Widget
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
                      IconButton(
                        splashRadius: 16,
                        iconSize: 16,
                        visualDensity: VisualDensity.compact,
                        onPressed: onChevronTap,
                        icon: Icon(
                          isExpanded!
                              ? PhosphorIcons.caretUp(PhosphorIconsStyle.bold)
                              : PhosphorIcons.caretDown(
                                  PhosphorIconsStyle.bold,
                                ),
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
