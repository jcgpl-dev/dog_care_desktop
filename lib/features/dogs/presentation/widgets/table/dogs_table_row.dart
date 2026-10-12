import 'dart:io';

import 'package:dog_care_desktop/config/theme/app_colors.dart';
import 'package:dog_care_desktop/config/theme/app_dimensions.dart';
import 'package:dog_care_desktop/config/theme/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../domain/entities/dog.dart';
import '../../utils/dog_formatters.dart';
import '../common/dog_sex_badge.dart';
import 'dogs_table_columns.dart';

enum _RowAction { edit, delete }

class DogsTableRow extends StatelessWidget {
  const DogsTableRow({
    super.key,
    required this.dog,
    required this.isSelected,
    required this.onToggleSelection,
    required this.onOpen,
    required this.onDelete,
  });

  final Dog dog;
  final bool isSelected;
  final VoidCallback onToggleSelection;
  final VoidCallback onOpen;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? AppColors.darkText : AppColors.textPrimary;
    final cellStyle = AppTextStyles.bodyMedium.copyWith(color: textColor);

    return Material(
      color: isSelected
          ? AppColors.primary.withValues(alpha: 0.08)
          : Colors.transparent,
      child: InkWell(
        onTap: onOpen,
        // Customize your splash and highlight colors here:
        splashColor: AppColors.primary.withValues(alpha: 0.12),
        highlightColor: AppColors.primary.withValues(alpha: 0.04),
        // Optional: Add a border radius if your rows have rounded corners
        borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
        child: Container(
          height: DogsTableLayout.rowHeight,
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: isDark ? AppColors.darkBorder : AppColors.background,
              ),
            ),
          ),
          child: Row(
            children: [
              SizedBox(
                width: DogsTableLayout.checkboxWidth,
                child: Center(
                  child: Theme(
                    data: Theme.of(context).copyWith(
                      checkboxTheme: CheckboxThemeData(
                        // Shape and border radius matching your design system
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            AppDimensions.radiusSmall - 2,
                          ),
                        ),
                        // Fill color when checked
                        fillColor: WidgetStateProperty.resolveWith((states) {
                          if (states.contains(WidgetState.selected)) {
                            return AppColors.primary;
                          }
                          return Colors
                              .transparent; // Transparent when unchecked
                        }),
                        // Checkmark color
                        checkColor: WidgetStateProperty.all(Colors.white),
                        // Border color when unchecked
                        side: BorderSide(
                          color: isDark
                              ? AppColors.darkBorder
                              : AppColors.border,
                          width: 1.5,
                        ),
                      ),
                    ),
                    child: Checkbox(
                      value: isSelected,
                      onChanged: (_) => onToggleSelection(),
                    ),
                  ),
                ),
              ),
              // _cell(
              //   DogsTableColumn.id,
              //   Text(
              //     dog.id,
              //     overflow: TextOverflow.ellipsis,
              //     style: cellStyle.copyWith(color: AppColors.textSecondary),
              //   ),
              // ),
              _cell(
                DogsTableColumn.petName,
                _PetCell(dog: dog, color: textColor),
              ),
              _cell(
                DogsTableColumn.breed,
                Text(
                  dog.breed,
                  overflow: TextOverflow.ellipsis,
                  style: cellStyle,
                ),
              ),
              _cell(
                DogsTableColumn.age,
                Tooltip(
                  message: 'Born ${DogFormatters.date(dog.birthdate)}',
                  child: Text(
                    DogFormatters.age(dog.birthdate),
                    style: cellStyle,
                  ),
                ),
              ),
              _cell(DogsTableColumn.sex, DogSexBadge(sex: dog.sex)),
              _cell(
                DogsTableColumn.owner,
                Text(
                  dog.ownerName,
                  overflow: TextOverflow.ellipsis,
                  style: cellStyle.copyWith(fontWeight: FontWeight.w500),
                ),
              ),
              _cell(
                DogsTableColumn.address,
                Text(
                  dog.address,
                  overflow: TextOverflow.ellipsis,
                  style: cellStyle,
                ),
              ),
              _cell(
                DogsTableColumn.contact,
                Text(
                  dog.contactNumber,
                  overflow: TextOverflow.ellipsis,
                  style: cellStyle,
                ),
              ),
              SizedBox(
                width: DogsTableLayout.actionsWidth,
                child: PopupMenuButton<_RowAction>(
                  tooltip: 'Actions for ${dog.petName}',
                  icon: Icon(
                    PhosphorIcons.dotsThreeVertical(PhosphorIconsStyle.bold),
                    size: AppDimensions.spacing20,
                    color: AppColors.textSecondary,
                  ),
                  onSelected: (action) => switch (action) {
                    _RowAction.edit => onOpen(),
                    _RowAction.delete => onDelete(),
                  },
                  itemBuilder: (_) => [
                    PopupMenuItem(
                      value: _RowAction.edit,
                      child: _MenuLabel(
                        icon: PhosphorIcons.pencil(PhosphorIconsStyle.bold),
                        label: 'Edit',
                      ),
                    ),
                    PopupMenuItem(
                      value: _RowAction.delete,
                      child: _MenuLabel(
                        icon: PhosphorIcons.trash(PhosphorIconsStyle.bold),
                        label: 'Delete',
                        color: AppColors.error,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _cell(DogsTableColumn column, Widget child) => Expanded(
    flex: column.flex,
    child: Padding(
      padding: const EdgeInsets.only(right: 12),
      child: Align(alignment: Alignment.centerLeft, child: child),
    ),
  );
}

class _PetCell extends StatelessWidget {
  const _PetCell({required this.dog, required this.color});

  final Dog dog;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircleAvatar(
          radius: AppDimensions.radiusLarge,
          backgroundColor: AppColors.primaryContainer,
          foregroundImage: dog.photoUrl != null
              ? ResizeImage(FileImage(File(dog.photoUrl!)), width: 48)
              : null,
          onForegroundImageError: dog.photoUrl != null ? (_, __) {} : null,
          child: Text(
            dog.petName.isNotEmpty ? dog.petName[0].toUpperCase() : 'D',
            style: AppTextStyles.labelSmall.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(width: AppDimensions.spacing8),
        Flexible(
          child: Text(
            dog.petName,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.titleSmall.copyWith(color: color),
          ),
        ),
      ],
    );
  }
}

class _MenuLabel extends StatelessWidget {
  const _MenuLabel({required this.icon, required this.label, this.color});

  final IconData icon;
  final String label;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: AppDimensions.spacing12),
        Text(label, style: TextStyle(color: color)),
      ],
    );
  }
}
