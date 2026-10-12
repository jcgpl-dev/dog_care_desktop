import 'package:dog_care_desktop/config/theme/app_colors.dart';
import 'package:dog_care_desktop/config/theme/app_dimensions.dart';
import 'package:dog_care_desktop/core/presentation/widgets/buttons/app_button.dart';
import 'package:dog_care_desktop/core/presentation/widgets/inputs/app_search_field.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../models/dogs_query.dart';

enum _ToolbarLayout { wide, compact, stacked }

class DogsToolbar extends StatefulWidget {
  const DogsToolbar({
    super.key,
    required this.sexFilter,
    required this.onSearchChanged,
    required this.onSexFilterChanged,
    required this.onRegisterPressed,
  });

  final DogSexFilter sexFilter;
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<DogSexFilter> onSexFilterChanged;
  final VoidCallback onRegisterPressed;

  @override
  State<DogsToolbar> createState() => _DogsToolbarState();
}

class _DogsToolbarState extends State<DogsToolbar> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  _ToolbarLayout _layoutFor(double width) {
    if (width >= 640) return _ToolbarLayout.wide;
    if (width >= 420) return _ToolbarLayout.compact;
    return _ToolbarLayout.stacked;
  }

  Widget _registerButton() => AppButton(
    label: 'Register Dog',
    icon: Icon(
      PhosphorIcons.plus(PhosphorIconsStyle.bold),
      size: AppDimensions.spacing20,
      color: Colors.white,
    ),
    backgroundColor: AppColors.primary,
    foregroundColor: Colors.white,
    onPressed: widget.onRegisterPressed,
  );

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final layout = _layoutFor(constraints.maxWidth);

        final search = AppSearchField(
          controller: _searchController,
          hint: layout == _ToolbarLayout.wide
              ? 'Search by pet, breed, owner, address, or ID...'
              : 'Search dogs...',
          onChanged: widget.onSearchChanged,
        );

        switch (layout) {
          case _ToolbarLayout.wide:
            return Row(
              children: [
                Expanded(child: search),
                const SizedBox(width: AppDimensions.spacing16),
                _SexFilterMenu(
                  value: widget.sexFilter,
                  onChanged: widget.onSexFilterChanged,
                ),
                const SizedBox(width: AppDimensions.spacing16),
                SizedBox(width: 160, child: _registerButton()),
              ],
            );

          case _ToolbarLayout.compact:
            return Row(
              children: [
                Expanded(child: search),
                const SizedBox(width: AppDimensions.spacing12),
                _SexFilterMenu(
                  value: widget.sexFilter,
                  onChanged: widget.onSexFilterChanged,
                  compact: true,
                ),
                const SizedBox(width: AppDimensions.spacing12),
                _RegisterIconButton(onPressed: widget.onRegisterPressed),
              ],
            );

          case _ToolbarLayout.stacked:
            return Column(
              children: [
                search,
                const SizedBox(height: AppDimensions.spacing12),
                Row(
                  children: [
                    Expanded(
                      child: _SexFilterMenu(
                        value: widget.sexFilter,
                        onChanged: widget.onSexFilterChanged,
                        expand: true,
                      ),
                    ),
                    const SizedBox(width: AppDimensions.spacing12),
                    Expanded(child: _registerButton()),
                  ],
                ),
              ],
            );
        }
      },
    );
  }
}

class _RegisterIconButton extends StatelessWidget {
  const _RegisterIconButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: 'Register Dog',
      child: SizedBox(
        width: AppDimensions.buttonHeight,
        height: AppDimensions.buttonHeight,
        child: FilledButton(
          onPressed: onPressed,
          style: FilledButton.styleFrom(
            padding: EdgeInsets.zero,
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
            ),
          ),
          child: Icon(
            PhosphorIcons.plus(PhosphorIconsStyle.bold),
            size: AppDimensions.spacing20,
          ),
        ),
      ),
    );
  }
}

class _SexFilterMenu extends StatelessWidget {
  const _SexFilterMenu({
    required this.value,
    required this.onChanged,
    this.compact = false,
    this.expand = false,
  });

  final DogSexFilter value;
  final ValueChanged<DogSexFilter> onChanged;

  /// Icon-only with a dot when a filter is active.
  final bool compact;

  /// Fills the width it is given (used in the stacked layout).
  final bool expand;

  static const _labels = {
    DogSexFilter.all: 'All sexes',
    DogSexFilter.male: 'Male',
    DogSexFilter.female: 'Female',
  };

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final isActive = value != DogSexFilter.all;
    final label = isActive ? 'Sex: ${_labels[value]}' : 'Filter';

    // Match AppTextField / AppSearchField color logic
    final effectiveFillColor = isDarkMode
        ? AppColors.darkFieldBackground
        : AppColors.surface;

    final effectiveBorderColor = isActive
        ? (isDarkMode ? AppColors.primaryContainer : AppColors.primary)
        : (isDarkMode ? AppColors.darkBorder : AppColors.border);

    final color = isActive
        ? (isDarkMode ? AppColors.primaryContainer : AppColors.primary)
        : (isDarkMode ? AppColors.darkTextSecondary : AppColors.textSecondary);

    final icon = Icon(
      PhosphorIcons.funnel(PhosphorIconsStyle.bold),
      size: 18,
      color: color,
    );

    return PopupMenuButton<DogSexFilter>(
      tooltip: isActive ? label : 'Filter by sex',
      initialValue: value,
      onSelected: onChanged,
      itemBuilder: (_) => [
        for (final entry in _labels.entries)
          CheckedPopupMenuItem(
            value: entry.key,
            checked: entry.key == value,
            child: Text(entry.value),
          ),
      ],
      child: Container(
        height: AppDimensions.buttonHeight,
        width: compact ? AppDimensions.buttonHeight : null,
        padding: compact
            ? EdgeInsets.zero
            : const EdgeInsets.symmetric(horizontal: AppDimensions.spacing16),
        decoration: BoxDecoration(
          color: isActive
              ? AppColors.primary.withValues(alpha: 0.1)
              : effectiveFillColor,
          border: Border.all(
            color: effectiveBorderColor,
            width: isActive ? 2 : 1, // Matches focused border width style
          ),
          borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
        ),
        child: compact
            ? Stack(
                alignment: Alignment.center,
                children: [
                  icon,
                  if (isActive)
                    Positioned(
                      top: 9,
                      right: 9,
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                ],
              )
            : Row(
                mainAxisSize: expand ? MainAxisSize.max : MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  icon,
                  const SizedBox(width: AppDimensions.spacing8),
                  Flexible(
                    child: Text(
                      label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: color,
                        fontWeight: isActive
                            ? FontWeight.w600
                            : FontWeight.normal,
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
