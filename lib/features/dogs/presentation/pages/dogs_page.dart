import 'dart:ffi';

import 'package:dog_care_desktop/config/theme/app_colors.dart';
import 'package:dog_care_desktop/config/theme/app_dimensions.dart';
import 'package:dog_care_desktop/config/theme/app_text_styles.dart';
import 'package:dog_care_desktop/core/presentation/widgets/cards/app_metric_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/dog.dart';
import '../bloc/dogs_bloc.dart';
import '../widgets/dogs_data_table.dart';
import '../widgets/dog_registration_sidebar.dart';

class DogsPage extends StatefulWidget {
  const DogsPage({super.key});

  @override
  State<DogsPage> createState() => _DogsPageState();
}

class _DogsPageState extends State<DogsPage> {
  bool _isSidebarOpen = false;
  Dog? _dogToEdit;
  double appDimensions = AppDimensions.spacing16;

  @override
  void initState() {
    super.initState();
    context.read<DogsBloc>().add(const FetchDogsRequested());
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Row(
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(appDimensions),
              child: BlocBuilder<DogsBloc, DogsState>(
                builder: (context, state) {
                  List<Dog> filteredDogs = [];
                  Set<String> selectedDogIds = {};

                  if (state is DogsLoaded) {
                    filteredDogs = state.filteredDogs;
                    selectedDogIds = state.selectedDogIds;
                  }

                  return Column(
                    children: [
                      // Section 2: Metric cards
                      Row(
                        children: [
                          Expanded(
                            child: AppMetricCard(
                              title: 'Total Dogs',
                              value: '${filteredDogs.length}',
                              icon: Icons.pets,
                              accentColor: AppColors.primary,
                            ),
                          ),
                          SizedBox(width: appDimensions),
                          Expanded(
                            child: AppMetricCard(
                              title: 'Active Dogs',
                              value: '${filteredDogs.length}',
                              icon: Icons.check_circle,
                              accentColor: AppColors.success,
                            ),
                          ),
                          SizedBox(width: appDimensions),
                          const Expanded(
                            child: AppMetricCard(
                              title: 'Sample',
                              value: '23',
                              icon: Icons.mood,
                              accentColor: AppColors.info,
                            ),
                          ),
                          SizedBox(width: appDimensions),
                          const Expanded(
                            child: AppMetricCard(
                              title: 'Sample1',
                              value: '33',
                              icon: Icons.air_outlined,
                              accentColor: AppColors.warning,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: appDimensions),

                      // Section 1: Toolbar / header
                      Row(
                        children: [
                          // Search bar
                          Expanded(
                            flex: 6,
                            child: Container(
                              height: AppDimensions.topBarHeight,
                              padding: EdgeInsets.symmetric(
                                horizontal: appDimensions,
                              ),
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.surface,
                              ),
                              child: Center(
                                child: TextField(
                                  onChanged: (query) {
                                    context.read<DogsBloc>().add(
                                      SearchDogsQueryChanged(query),
                                    );
                                  },
                                  decoration: InputDecoration(
                                    fillColor: Colors.transparent,
                                    hintText:
                                        'Search by pet name, breed, owner, or ID...',
                                    border: InputBorder.none,
                                    enabledBorder: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                    disabledBorder: InputBorder.none,
                                    errorBorder: InputBorder.none,
                                    focusedErrorBorder: InputBorder.none,
                                    hintStyle: TextStyle(
                                      color: AppColors.textSecondary,
                                    ),
                                    prefixIcon: Icon(
                                      Icons.search,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: appDimensions),

                          // Filter dropdown
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                // Trigger filter action if needed
                              },
                              child: Container(
                                height: AppDimensions.topBarHeight,
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.surface,
                                ),
                                child: Center(
                                  child: Text(
                                    'Filter',
                                    style: AppTextStyles.bodyLarge,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: appDimensions),
                          // Filter dropdown
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                // Trigger filter action if needed
                              },
                              child: Container(
                                height: AppDimensions.topBarHeight,
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.surface,
                                ),
                                child: Center(
                                  child: Text(
                                    'Export',
                                    style: AppTextStyles.bodyLarge,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: appDimensions),

                          // Add/Register button
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _dogToEdit = null;
                                  _isSidebarOpen = true;
                                });
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: appDimensions,
                                ),
                                height: AppDimensions.topBarHeight,
                                decoration: BoxDecoration(
                                  color: AppColors.primary,
                                ),
                                child: Center(
                                  child: Text(
                                    'Register Dog',
                                    overflow: TextOverflow.ellipsis,
                                    style: AppTextStyles.labelLarge.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: appDimensions),

                      // Section 3: Main content area / Data table
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                              AppDimensions.radiusSmall,
                            ),
                            color: Theme.of(context).colorScheme.surface,
                          ),
                          child: ClipRRect(
                            child: state is DogsLoading || state is DogsInitial
                                ? const Center(
                                    child: CircularProgressIndicator(),
                                  )
                                : state is DogsError
                                ? Center(child: Text('Error: ${state.message}'))
                                : DogsDataTable(
                                    dogs: filteredDogs,
                                    selectedDogIds: selectedDogIds,
                                    onEditDog: (dog) {
                                      setState(() {
                                        _dogToEdit = dog;
                                        _isSidebarOpen = true;
                                      });
                                    },
                                    onDeleteDog: (dogId) {
                                      context.read<DogsBloc>().add(
                                        DeleteDogRequested(dogId),
                                      );
                                    },
                                    onBulkDelete: () {
                                      for (final id in selectedDogIds) {
                                        context.read<DogsBloc>().add(
                                          DeleteDogRequested(id),
                                        );
                                      }
                                      context.read<DogsBloc>().add(
                                        const ClearDogSelections(),
                                      );
                                    },
                                  ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
          if (_isSidebarOpen)
            DogRegistrationSidebar(
              dogToEdit: _dogToEdit,
              onClose: () => setState(() => _isSidebarOpen = false),
            ),
        ],
      ),
    );
  }
}
