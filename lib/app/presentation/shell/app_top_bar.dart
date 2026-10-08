import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:dog_care_desktop/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_dimensions.dart';
import '../../../../config/theme/cubit/theme_cubit.dart';
import 'cubit/sidebar_cubit.dart';
import '../../../../core/presentation/widgets/app_window/window_controls.dart';

class AppTopBar extends StatelessWidget {
  const AppTopBar({super.key});

  String _getPageTitle(String location) {
    switch (location) {
      case '/dashboard':
        return 'Dashboard';
      case '/dogs':
        return 'Dogs Management';
      case '/health-records':
        return 'Health Records';
      case '/services':
        return 'Services';
      case '/vaccinations':
        return 'Vaccinations';
      case '/deworming':
        return 'Deworming';
      case '/treatments':
        return 'Treatments';
      case '/appointments':
        return 'Appointments';
      case '/reports':
        return 'Reports';
      case '/alerts':
        return 'Alerts';
      case '/manage-users':
        return 'User Management';
      case '/settings':
        return 'Settings';
      default:
        return 'Dashboard';
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final currentPath = GoRouterState.of(context).matchedLocation;

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
          _buildSidebarToggleButton(context),
          Expanded(
            child: MoveWindow(
              child: Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: AppDimensions.spacing8),
                  child: Text(
                    _getPageTitle(currentPath),
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
              ),
            ),
          ),
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
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        final userName = state is AuthAuthenticated ? state.user.name : 'User';

        return PopupMenuButton<String>(
          tooltip: 'Account',
          onSelected: (value) {
            if (value == 'logout') {
              context.read<AuthBloc>().add(const AuthLogoutRequested());
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
              Text(userName, style: Theme.of(context).textTheme.labelLarge),
              const Icon(Icons.keyboard_arrow_down, size: 18),
            ],
          ),
        );
      },
    );
  }
}
