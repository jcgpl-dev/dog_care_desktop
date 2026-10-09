// lib/app/presentation/shell/app_top_bar.dart
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:dog_care_desktop/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_dimensions.dart';
import '../../../../config/theme/app_text_styles.dart';
import '../../../../config/theme/cubit/theme_cubit.dart';
import '../../../../core/presentation/widgets/app_window/window_controls.dart';
import 'cubit/sidebar_cubit.dart';
import 'widgets/app_breadcrumbs.dart';

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
          _buildSidebarToggleButton(context),
          Expanded(
            child: MoveWindow(
              child: Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: AppDimensions.spacing8),
                  child: const AppBreadcrumbs(),
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
            splashRadius: AppDimensions.spacing16 + AppDimensions.spacing2,
            iconSize: AppDimensions.spacing20,
            onPressed: () => context.read<SidebarCubit>().toggleSidebar(),
            icon: Icon(PhosphorIcons.list(PhosphorIconsStyle.bold)),
          ),
        );
      },
    );
  }

  Widget _buildThemeToggleButton(BuildContext context, bool isDarkMode) {
    return IconButton(
      tooltip: isDarkMode ? 'Switch to Light Mode' : 'Switch to Dark Mode',
      splashRadius: AppDimensions.spacing16 + AppDimensions.spacing2,
      iconSize: AppDimensions.spacing20,
      onPressed: () => context.read<ThemeCubit>().toggleTheme(),
      icon: Icon(
        isDarkMode
            ? PhosphorIcons.sun(PhosphorIconsStyle.bold)
            : PhosphorIcons.moon(PhosphorIconsStyle.bold),
      ),
    );
  }

  Widget _buildNotificationButton() {
    return IconButton(
      tooltip: 'Notifications',
      splashRadius: AppDimensions.spacing16 + AppDimensions.spacing2,
      iconSize: AppDimensions.spacing20,
      onPressed: () {},
      icon: Icon(PhosphorIcons.bell(PhosphorIconsStyle.bold)),
    );
  }

  Widget _buildUserMenu(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        final userName = state is AuthAuthenticated ? state.user.name : 'User';

        return PopupMenuButton<String>(
          tooltip: 'Account Options',
          onSelected: (value) {
            if (value == 'logout') {
              context.read<AuthBloc>().add(const AuthLogoutRequested());
            }
          },
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 'profile',
              child: Text('Profile', style: AppTextStyles.bodyMedium),
            ),
            PopupMenuItem(
              value: 'logout',
              child: Text('Sign out', style: AppTextStyles.bodyMedium),
            ),
          ],
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: AppDimensions.spacing12 + AppDimensions.spacing2,
                backgroundColor: AppColors.primaryContainer,
                child: Icon(
                  PhosphorIcons.user(PhosphorIconsStyle.bold),
                  size: AppDimensions.spacing16,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: AppDimensions.spacing8),
              Text(
                userName,
                style: AppTextStyles.labelLarge.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: AppDimensions.spacing4),
              Icon(
                PhosphorIcons.caretDown(PhosphorIconsStyle.bold),
                size: AppDimensions.spacing12 + AppDimensions.spacing2,
              ),
            ],
          ),
        );
      },
    );
  }
}
