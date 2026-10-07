import 'package:flutter/material.dart';

import '../../../config/theme/app_colors.dart';
import '../../../config/theme/app_dimensions.dart';

class AppTopBar extends StatelessWidget {
  const AppTopBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacing24),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'Dashboard',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),

          _buildNotificationButton(),

          const SizedBox(width: AppDimensions.spacing12),

          _buildUserMenu(context),
        ],
      ),
    );
  }

  Widget _buildNotificationButton() {
    return IconButton(
      tooltip: 'Notifications',
      onPressed: () {},
      icon: const Icon(Icons.notifications_none_outlined),
    );
  }

  Widget _buildUserMenu(BuildContext context) {
    return PopupMenuButton<String>(
      tooltip: 'Account',
      onSelected: (value) {
        if (value == 'logout') {
          // Logout will be connected to AuthBloc later.
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
            radius: 18,
            backgroundColor: AppColors.primaryContainer,
            child: const Icon(
              Icons.person_outline,
              size: 20,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(width: AppDimensions.spacing8),
          Text('Administrator', style: Theme.of(context).textTheme.labelLarge),
          const Icon(Icons.keyboard_arrow_down, size: 20),
        ],
      ),
    );
  }
}
