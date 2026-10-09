import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../config/theme/app_colors.dart';
import '../../../config/theme/app_dimensions.dart';
import '../../../config/theme/app_text_styles.dart';
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
      icon: Icon(PhosphorIcons.squaresFour(PhosphorIconsStyle.bold)),
      route: '/dashboard',
    ),
    AppNavigationItem(
      label: 'Dogs',
      icon: Icon(PhosphorIcons.dog(PhosphorIconsStyle.bold)),
      route: '/dogs',
    ),
    AppNavigationItem(
      label: 'Owners',
      icon: Icon(PhosphorIcons.user(PhosphorIconsStyle.bold)),
      route: '/owners',
    ),
    AppNavigationItem(
      label: 'Health Records',
      icon: Icon(PhosphorIcons.heartbeat(PhosphorIconsStyle.bold)),
      route: '/health-records',
    ),
    AppNavigationItem(
      label: 'Services',
      icon: Icon(PhosphorIcons.firstAid(PhosphorIconsStyle.bold)),
      route: '/services',
      children: [
        AppNavigationItem(
          label: 'Vaccinations',
          icon: Icon(PhosphorIcons.syringe(PhosphorIconsStyle.bold)),
          route: '/services/vaccinations',
        ),
        AppNavigationItem(
          label: 'Deworming',
          icon: Icon(PhosphorIcons.pill(PhosphorIconsStyle.bold)),
          route: '/services/deworming',
        ),
        AppNavigationItem(
          label: 'Treatments',
          icon: Icon(PhosphorIcons.stethoscope(PhosphorIconsStyle.bold)),
          route: '/services/treatments',
        ),
      ],
    ),
    AppNavigationItem(
      label: 'Appointments',
      icon: Icon(PhosphorIcons.calendarBlank(PhosphorIconsStyle.bold)),
      route: '/appointments',
    ),
    AppNavigationItem(
      label: 'Reports',
      icon: Icon(PhosphorIcons.fileText(PhosphorIconsStyle.bold)),
      route: '/reports',
    ),
    AppNavigationItem(
      label: 'Alerts',
      icon: Icon(PhosphorIcons.bell(PhosphorIconsStyle.bold)),
      route: '/alerts',
    ),
  ];

  static final _adminItems = [
    AppNavigationItem(
      label: 'Manage Users',
      icon: Icon(PhosphorIcons.users(PhosphorIconsStyle.bold)),
      route: '/manage-users',
    ),
    AppNavigationItem(
      label: 'Settings',
      icon: Icon(PhosphorIcons.gear(PhosphorIconsStyle.bold)),
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
                          style: AppTextStyles.labelSmall.copyWith(
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
                width: AppDimensions.buttonHeight,
                height: AppDimensions.buttonHeight,
                child: Center(
                  child: Container(
                    width: AppDimensions.spacing32,
                    height: AppDimensions.spacing32,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(
                        AppDimensions.radiusSmall,
                      ),
                    ),
                    child: Icon(
                      PhosphorIcons.pawPrint(PhosphorIconsStyle.fill),
                      size: AppDimensions.spacing16 + AppDimensions.spacing2,
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
                    style: AppTextStyles.titleLarge.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
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

    // Check if path matches exactly or if it is a parent path of the current sub-route
    final isSelected =
        item.route != null &&
        (currentPath == item.route ||
            (item.hasChildren && currentPath.startsWith('${item.route}/')));

    final activeBgColor = isDarkMode
        ? AppColors.primary.withValues(alpha: 0.18)
        : AppColors.primaryContainer;
    final activeItemColor = isDarkMode
        ? AppColors.primaryContainer
        : AppColors.primary;
    final unselectedIconColor = isDarkMode
        ? AppColors.darkTextSecondary
        : AppColors.textSecondary;

    final iconSize = isSubItem
        ? AppDimensions.spacing16 + 2
        : AppDimensions.spacing20;

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
            height: AppDimensions.spacing40,
            child: ClipRect(
              child: Row(
                children: [
                  SizedBox(
                    width: AppDimensions.buttonHeight,
                    height: AppDimensions.spacing40,
                    child: Center(
                      child: IconTheme(
                        data: IconThemeData(
                          size: iconSize,
                          color: isSelected
                              ? activeItemColor
                              : unselectedIconColor,
                        ),
                        child: item.icon,
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
                          style: AppTextStyles.labelLarge.copyWith(
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
                        splashRadius: AppDimensions.spacing16,
                        iconSize: AppDimensions.spacing16,
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
