import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/dog.dart';
import '../bloc/dogs_bloc.dart';
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
            child: Column(
              children: [
                DogsToolbar(
                  onRegisterPressed: () {
                    setState(() {
                      _dogToEdit = null;
                      _isSidebarOpen = true;
                    });
                  },
                ),
                Expanded(
                  child: BlocBuilder<DogsBloc, DogsState>(
                    builder: (context, state) {
                      if (state is DogsLoading || state is DogsInitial) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (state is DogsLoaded) {
                        return DogsDataTable(
                          dogs: state.filteredDogs,
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
                        );
                      } else if (state is DogsError) {
                        return Center(child: Text('Error: ${state.message}'));
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ),
              ],
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
