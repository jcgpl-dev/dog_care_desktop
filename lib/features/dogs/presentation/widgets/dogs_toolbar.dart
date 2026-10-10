import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_dimensions.dart';
import '../../../../core/presentation/widgets/buttons/app_button.dart';
import '../../../../core/presentation/widgets/inputs/app_search_field.dart';
import '../bloc/dogs_bloc.dart';

class DogsToolbar extends StatelessWidget {
  final VoidCallback onRegisterPressed;

  const DogsToolbar({super.key, required this.onRegisterPressed});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.spacing24,
        vertical: AppDimensions.spacing16,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: isDarkMode ? AppColors.darkBorder : AppColors.border,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            flex: 2,
            child: AppSearchField(
              hint: 'Search by pet name, breed, owner, or ID...',
              onChanged: (query) {
                context.read<DogsBloc>().add(SearchDogsQueryChanged(query));
              },
            ),
          ),
          const SizedBox(width: AppDimensions.spacing16),
          SizedBox(
            width: 160,
            child: AppButton(
              label: 'Register Dog',
              icon: Icon(
                PhosphorIcons.plus(PhosphorIconsStyle.bold),
                size: AppDimensions.spacing20,
                color: Colors.white,
              ),
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              onPressed: onRegisterPressed,
            ),
          ),
        ],
      ),
    );
  }
}
