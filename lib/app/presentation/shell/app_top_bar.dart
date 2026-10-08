import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_dimensions.dart';
import '../../../../config/theme/cubit/theme_cubit.dart';
import 'cubit/sidebar_cubit.dart';
import '../../../../core/presentation/widgets/app_window/window_controls.dart';

class AppTopBar extends StatelessWidget {
  const AppTopBar({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      height: AppDimensions.topBarHeight,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: isDarkMode ? AppColors.darkBorder : AppColors.border,
          ),
        ),
      ),
      child: Row(
        children: [
          // Hamburger Toggle Button
          _buildSidebarToggleButton(context),

          // Draggable Title Area
          Expanded(
            child: MoveWindow(
              child: Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: AppDimensions.spacing8),
                  child: Text(
                    'Dashboard',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
              ),
            ),
          ),

          // Action Items
          _buildThemeToggleButton(context, isDarkMode),
          const SizedBox(width: AppDimensions.spacing4),
          _buildNotificationButton(),
          const SizedBox(width: AppDimensions.spacing8),
          _buildUserMenu(context),
          const SizedBox(width: AppDimensions.spacing12),
          WindowControls(isDark: isDarkMode),
        ],
      ),
    );
  }

  Widget _buildSidebarToggleButton(BuildContext context) {
    return BlocBuilder<SidebarCubit, bool>(
      builder: (context, isCollapsed) {
        return Padding(
          padding: const EdgeInsets.only(left: AppDimensions.spacing8),
          child: IconButton(
            tooltip: isCollapsed ? 'Expand Sidebar' : 'Collapse Sidebar',
            splashRadius: 18,
            iconSize: 20,
            onPressed: () => context.read<SidebarCubit>().toggleSidebar(),
            icon: Transform.flip(
              flipX: isCollapsed,
              child: Icon(isCollapsed ? Icons.menu_open : Icons.menu),
            ),
          ),
        );
      },
    );
  }

  Widget _buildThemeToggleButton(BuildContext context, bool isDarkMode) {
    return IconButton(
      tooltip: isDarkMode ? 'Switch to Light Mode' : 'Switch to Dark Mode',
      splashRadius: 18,
      iconSize: 20,
      onPressed: () => context.read<ThemeCubit>().toggleTheme(),
      icon: Icon(
        isDarkMode ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
      ),
    );
  }

  Widget _buildNotificationButton() {
    return IconButton(
      tooltip: 'Notifications',
      splashRadius: 18,
      iconSize: 20,
      onPressed: () {},
      icon: const Icon(Icons.notifications_none_outlined),
    );
  }

  Widget _buildUserMenu(BuildContext context) {
    return PopupMenuButton<String>(
      tooltip: 'Account',
      onSelected: (value) {
        if (value == 'logout') {
          // Connected to AuthBloc logout logic
        }
      },
      itemBuilder: (context) => const [
        PopupMenuItem(value: 'profile', child: Text('Profile')),
        PopupMenuItem(value: 'logout', child: Text('Sign out')),
      ],
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 14,
            backgroundColor: AppColors.primaryContainer,
            child: const Icon(
              Icons.person_outline,
              size: 16,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(width: AppDimensions.spacing8),
          Text('Administrator', style: Theme.of(context).textTheme.labelLarge),
          const Icon(Icons.keyboard_arrow_down, size: 18),
        ],
      ),
    );
  }
}
