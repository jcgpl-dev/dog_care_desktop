import 'dart:math' as math;
import 'package:dog_care_desktop/core/presentation/widgets/table/app_table_container.dart';
import 'package:flutter/material.dart';

import '../../../domain/entities/dog.dart';
import '../../models/dogs_query.dart';
import 'dogs_table_columns.dart';
import 'dogs_table_header.dart';
import 'dogs_table_row.dart';

class DogsTable extends StatelessWidget {
  const DogsTable({
    super.key,
    required this.dogs,
    required this.selectedDogIds,
    required this.sortField,
    required this.ascending,
    required this.onSort,
    required this.onToggleSelection,
    required this.onToggleSelectAll,
    required this.onOpen,
    required this.onDelete,
    this.footer,
  });

  final List<Dog> dogs;
  final Set<String> selectedDogIds;
  final DogSortField sortField;
  final bool ascending;
  final ValueChanged<DogSortField> onSort;
  final ValueChanged<String> onToggleSelection;
  final VoidCallback onToggleSelectAll;
  final ValueChanged<Dog> onOpen;
  final ValueChanged<Dog> onDelete;
  final Widget? footer;

  bool? get _selectionState {
    final selectedOnPage = dogs
        .where((d) => selectedDogIds.contains(d.id))
        .length;
    if (selectedOnPage == 0) return false;
    return selectedOnPage == dogs.length ? true : null;
  }

  @override
  Widget build(BuildContext context) {
    return AppTableContainer(
      footer: footer,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final width = math.max(
            constraints.maxWidth,
            DogsTableLayout.minWidth,
          );
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SizedBox(
              width: width,
              child: Column(
                children: [
                  DogsTableHeader(
                    selectionState: _selectionState,
                    sortField: sortField,
                    ascending: ascending,
                    onSort: onSort,
                    onToggleSelectAll: onToggleSelectAll,
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: dogs.length,
                      itemExtent: DogsTableLayout.rowHeight,
                      itemBuilder: (context, index) {
                        final dog = dogs[index];
                        return DogsTableRow(
                          key: ValueKey(dog.id),
                          dog: dog,
                          isSelected: selectedDogIds.contains(dog.id),
                          onToggleSelection: () => onToggleSelection(dog.id),
                          onOpen: () => onOpen(dog),
                          onDelete: () => onDelete(dog),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
