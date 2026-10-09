import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:intl/intl.dart';

import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_dimensions.dart';
import '../../../../config/theme/app_text_styles.dart';
import '../../domain/entities/dog.dart';

class DogsDataTable extends StatelessWidget {
  final List<Dog> dogs;
  final Function(Dog) onEditDog;
  final Function(String) onDeleteDog;

  const DogsDataTable({
    super.key,
    required this.dogs,
    required this.onEditDog,
    required this.onDeleteDog,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    if (dogs.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              PhosphorIcons.dog(PhosphorIconsStyle.bold),
              size: 48,
              color: AppColors.textDisabled,
            ),
            const SizedBox(height: AppDimensions.spacing12),
            Text(
              'No registered dogs found',
              style: AppTextStyles.titleMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: ConstrainedBox(
              constraints: BoxConstraints(minWidth: constraints.maxWidth),
              child: DataTable(
                headingRowHeight: AppDimensions.sidebarHeaderHeight,
                dataRowMinHeight: 52,
                dataRowMaxHeight: 52,
                horizontalMargin: AppDimensions.spacing24,
                columnSpacing: AppDimensions.spacing24,
                border: TableBorder(
                  bottom: BorderSide(
                    color: isDarkMode ? AppColors.darkBorder : AppColors.border,
                  ),
                  horizontalInside: BorderSide(
                    color: isDarkMode ? AppColors.darkBorder : AppColors.border,
                  ),
                ),
                headingRowColor: WidgetStateProperty.all(
                  isDarkMode
                      ? const Color(0xFF1E1E1E)
                      : AppColors.surfaceVariant.withValues(alpha: 0.6),
                ),
                columns: const [
                  DataColumn(label: Text('ID')),
                  DataColumn(label: Text('Pet Name')),
                  DataColumn(label: Text('Species')),
                  DataColumn(label: Text('Breed')),
                  DataColumn(label: Text('Birthdate')),
                  DataColumn(label: Text('Sex')),
                  DataColumn(label: Text('Owner Name')),
                  DataColumn(label: Text('Address')),
                  DataColumn(label: Text('Contact Number')),
                  DataColumn(label: Text('Actions'), numeric: true),
                ],
                rows: dogs.map((dog) {
                  return DataRow(
                    cells: [
                      DataCell(
                        Text(
                          dog.id,
                          style: AppTextStyles.bodyMedium.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                      DataCell(
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CircleAvatar(
                              radius: AppDimensions.spacing12,
                              backgroundColor: AppColors.primaryContainer,
                              child: Text(
                                dog.petName.isNotEmpty ? dog.petName[0] : 'D',
                                style: AppTextStyles.labelSmall.copyWith(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(width: AppDimensions.spacing8),
                            Text(
                              dog.petName,
                              style: AppTextStyles.titleSmall.copyWith(
                                color: isDarkMode
                                    ? AppColors.darkText
                                    : AppColors.textPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      DataCell(
                        Text(dog.species, style: AppTextStyles.bodyMedium),
                      ),
                      DataCell(
                        Text(dog.breed, style: AppTextStyles.bodyMedium),
                      ),
                      DataCell(
                        Text(
                          DateFormat('yyyy-MM-dd').format(dog.birthdate),
                          style: AppTextStyles.bodyMedium,
                        ),
                      ),
                      DataCell(
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppDimensions.spacing8,
                            vertical: AppDimensions.spacing2,
                          ),
                          decoration: BoxDecoration(
                            color: dog.sex == DogSex.male
                                ? AppColors.info.withValues(alpha: 0.15)
                                : AppColors.secondary.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(
                              AppDimensions.radiusFull,
                            ),
                          ),
                          child: Text(
                            dog.sex.name.toUpperCase(),
                            style: AppTextStyles.labelSmall.copyWith(
                              color: dog.sex == DogSex.male
                                  ? AppColors.info
                                  : AppColors.secondary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      DataCell(
                        Text(
                          dog.ownerName,
                          style: AppTextStyles.bodyMedium.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      DataCell(
                        Text(dog.address, style: AppTextStyles.bodyMedium),
                      ),
                      DataCell(
                        Text(
                          dog.contactNumber,
                          style: AppTextStyles.bodyMedium,
                        ),
                      ),
                      DataCell(
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              icon: Icon(
                                PhosphorIcons.pencil(PhosphorIconsStyle.bold),
                                size: AppDimensions.spacing16,
                                color: AppColors.textSecondary,
                              ),
                              tooltip: 'Edit Record',
                              onPressed: () => onEditDog(dog),
                            ),
                            IconButton(
                              icon: Icon(
                                PhosphorIcons.trash(PhosphorIconsStyle.bold),
                                size: AppDimensions.spacing16,
                                color: AppColors.error,
                              ),
                              tooltip: 'Delete Record',
                              onPressed: () => onDeleteDog(dog.id),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
        );
      },
    );
  }
}
