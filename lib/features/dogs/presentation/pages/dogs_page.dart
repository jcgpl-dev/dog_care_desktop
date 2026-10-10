import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/dog.dart';
import '../bloc/dogs_bloc.dart';
import '../widgets/dogs_metric_cards.dart';
import '../widgets/dogs_toolbar.dart';
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

  @override
  void initState() {
    super.initState();
    context.read<DogsBloc>().add(const FetchDogsRequested());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Expanded(
            child: BlocBuilder<DogsBloc, DogsState>(
              builder: (context, state) {
                List<Dog> allDogs = [];
                List<Dog> filteredDogs = [];
                Set<String> selectedDogIds = {};

                if (state is DogsLoaded) {
                  allDogs = state.dogs;
                  filteredDogs = state.filteredDogs;
                  selectedDogIds = state.selectedDogIds;
                }

                return Column(
                  children: [
                    // 1. Top Metrics Summary Cards
                    if (state is DogsLoaded || state is DogsLoading)
                      DogsMetricCards(dogs: allDogs),

                    // 2. Action Toolbar (Search & Register CTA)
                    DogsToolbar(
                      onRegisterPressed: () {
                        setState(() {
                          _dogToEdit = null;
                          _isSidebarOpen = true;
                        });
                      },
                    ),

                    // 3. Data Table with Checkboxes & Bulk Actions
                    Expanded(
                      child: state is DogsLoading || state is DogsInitial
                          ? const Center(child: CircularProgressIndicator())
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
                  ],
                );
              },
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