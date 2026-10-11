import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:intl/intl.dart';

import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_dimensions.dart';
import '../../../../config/theme/app_text_styles.dart';
import '../../domain/entities/dog.dart';
import '../bloc/dogs_bloc.dart';

class DogsDataTable extends StatefulWidget {
  final List<Dog> dogs;
  final Set<String> selectedDogIds;
  final Function(Dog) onEditDog;
  final Function(String) onDeleteDog;
  final VoidCallback onBulkDelete;

  const DogsDataTable({
    super.key,
    required this.dogs,
    required this.selectedDogIds,
    required this.onEditDog,
    required this.onDeleteDog,
    required this.onBulkDelete,
  });

  @override
  State<DogsDataTable> createState() => _DogsDataTableState();
}

class _DogsDataTableState extends State<DogsDataTable> {
  int _currentPage = 0;
  int _rowsPerPage = 10;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    if (widget.dogs.isEmpty) {
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

    // Pagination calculations
    final totalRecords = widget.dogs.length;
    final totalPages = (totalRecords / _rowsPerPage).ceil();
    if (_currentPage >= totalPages && totalPages > 0) {
      _currentPage = totalPages - 1;
    }

    final startIndex = _currentPage * _rowsPerPage;
    final endIndex = (startIndex + _rowsPerPage).clamp(0, totalRecords);
    final paginatedDogs = widget.dogs.sublist(startIndex, endIndex);

    return Stack(
      children: [
        Column(
          children: [
            // Table content wrapped in Expanded to fill space cleanly
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minWidth: constraints.maxWidth,
                        ),
                        child: DataTable(
                          showCheckboxColumn: true,
                          onSelectAll: (selected) {
                            context.read<DogsBloc>().add(
                              const ToggleSelectAllDogs(),
                            );
                          },
                          headingRowHeight: AppDimensions.sidebarHeaderHeight,
                          dataRowMinHeight: 52,
                          dataRowMaxHeight: 52,
                          horizontalMargin: AppDimensions.spacing24,
                          columnSpacing: AppDimensions.spacing24,

                          headingRowColor: WidgetStateProperty.all(
                            isDarkMode
                                ? const Color(0xFF1E1E1E)
                                : AppColors.surfaceVariant,
                          ),
                          columns: const [
                            DataColumn(label: Text('Pet Name')),
                            DataColumn(label: Text('Breed')),
                            DataColumn(label: Text('Birthdate')),
                            DataColumn(label: Text('Sex')),
                            DataColumn(label: Text('Owner Name')),
                            DataColumn(label: Text('Address')),
                            DataColumn(label: Text('Contact Number')),
                            DataColumn(
                              label: Align(
                                alignment: Alignment.centerLeft,
                                child: Text('Actions'),
                              ),
                            ),
                          ],
                          rows: paginatedDogs.map((dog) {
                            final isSelected = widget.selectedDogIds.contains(
                              dog.id,
                            );
                            return DataRow(
                              selected: isSelected,
                              onSelectChanged: (selected) {
                                context.read<DogsBloc>().add(
                                  ToggleDogSelection(dog.id),
                                );
                              },
                              cells: [
                                DataCell(
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      CircleAvatar(
                                        radius: AppDimensions.spacing16,
                                        backgroundColor:
                                            AppColors.primaryContainer,
                                        child: Text(
                                          dog.petName.isNotEmpty
                                              ? dog.petName[0]
                                              : 'D',
                                          style: AppTextStyles.labelSmall
                                              .copyWith(
                                                color: AppColors.primary,
                                                fontWeight: FontWeight.bold,
                                              ),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: AppDimensions.spacing8,
                                      ),
                                      Text(
                                        dog.petName,
                                        style: AppTextStyles.titleSmall
                                            .copyWith(
                                              color: isDarkMode
                                                  ? AppColors.darkText
                                                  : AppColors.textPrimary,
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                                DataCell(
                                  Text(
                                    dog.breed,
                                    style: AppTextStyles.bodyMedium,
                                  ),
                                ),
                                DataCell(
                                  Text(
                                    DateFormat(
                                      'yyyy-MM-dd',
                                    ).format(dog.birthdate),
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
                                          ? AppColors.info.withValues(
                                              alpha: 0.15,
                                            )
                                          : AppColors.secondary.withValues(
                                              alpha: 0.15,
                                            ),
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
                                  Text(
                                    dog.address,
                                    style: AppTextStyles.bodyMedium,
                                  ),
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
                                          PhosphorIcons.pencil(
                                            PhosphorIconsStyle.bold,
                                          ),
                                          size: AppDimensions.spacing16,
                                          color: AppColors.textSecondary,
                                        ),
                                        tooltip: 'Edit Record',
                                        onPressed: () => widget.onEditDog(dog),
                                      ),
                                      IconButton(
                                        icon: Icon(
                                          PhosphorIcons.trash(
                                            PhosphorIconsStyle.bold,
                                          ),
                                          size: AppDimensions.spacing16,
                                          color: AppColors.error,
                                        ),
                                        tooltip: 'Delete Record',
                                        onPressed: () =>
                                            widget.onDeleteDog(dog.id),
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
              ),
            ),
            // Professional Footer Pagination Bar
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.spacing24,
                vertical: AppDimensions.spacing8,
              ),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                border: Border(
                  top: BorderSide(
                    color: isDarkMode ? AppColors.darkBorder : AppColors.border,
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Record count display
                  Text(
                    'Showing ${startIndex + 1} to $endIndex of $totalRecords records',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  // Rows per page & Pagination Controls
                  Row(
                    children: [
                      Text(
                        'Rows per page:',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(width: AppDimensions.spacing8),
                      DropdownButton<int>(
                        value: _rowsPerPage,
                        underline: const SizedBox.shrink(),
                        items: [5, 10, 20, 50].map((value) {
                          return DropdownMenuItem<int>(
                            value: value,
                            child: Text(
                              '$value',
                              style: AppTextStyles.bodySmall,
                            ),
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          if (newValue != null) {
                            setState(() {
                              _rowsPerPage = newValue;
                              _currentPage = 0;
                            });
                          }
                        },
                      ),
                      const SizedBox(width: AppDimensions.spacing24),
                      Text(
                        'Page ${_currentPage + 1} of ${totalPages == 0 ? 1 : totalPages}',
                        style: AppTextStyles.bodySmall,
                      ),
                      const SizedBox(width: AppDimensions.spacing12),
                      IconButton(
                        icon: const Icon(Icons.chevron_left, size: 20),
                        onPressed: _currentPage > 0
                            ? () => setState(() => _currentPage--)
                            : null,
                      ),
                      IconButton(
                        icon: const Icon(Icons.chevron_right, size: 20),
                        onPressed: _currentPage < totalPages - 1
                            ? () => setState(() => _currentPage++)
                            : null,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        // Floating Bulk Action Toolbar (Appears when items are selected)
        if (widget.selectedDogIds.isNotEmpty)
          Positioned(
            bottom: AppDimensions.spacing24 + 50, // Offset above pagination bar
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.spacing20,
                  vertical: AppDimensions.spacing12,
                ),
                decoration: BoxDecoration(
                  color: isDarkMode
                      ? const Color(0xFF2D2D2D)
                      : AppColors.textPrimary,
                  borderRadius: BorderRadius.circular(
                    AppDimensions.radiusLarge,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${widget.selectedDogIds.length} selected',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: AppDimensions.spacing24),
                    ElevatedButton.icon(
                      onPressed: widget.onBulkDelete,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.error,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(0, 36),
                      ),
                      icon: Icon(
                        PhosphorIcons.trash(PhosphorIconsStyle.bold),
                        size: 16,
                      ),
                      label: const Text('Delete Selected'),
                    ),
                    const SizedBox(width: AppDimensions.spacing8),
                    TextButton(
                      onPressed: () {
                        context.read<DogsBloc>().add(
                          const ClearDogSelections(),
                        );
                      },
                      child: Text(
                        'Cancel',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.textDisabled,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}
