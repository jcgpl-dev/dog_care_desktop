import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/dog.dart';
import '../../domain/usecases/delete_dog.dart';
import '../../domain/usecases/get_dogs.dart';
import '../../domain/usecases/register_dog.dart';

part 'dogs_event.dart';
part 'dogs_state.dart';

class DogsBloc extends Bloc<DogsEvent, DogsState> {
  final GetDogs getDogs;
  final RegisterDog registerDog;
  final DeleteDog deleteDog;

  DogsBloc({
    required this.getDogs,
    required this.registerDog,
    required this.deleteDog,
  }) : super(const DogsInitial()) {
    on<FetchDogsRequested>(_onFetchDogs);
    on<AddDogRequested>(_onAddDog);
    on<DeleteDogRequested>(_onDeleteDog);
    on<SearchDogsQueryChanged>(_onSearchQueryChanged);
  }

  Future<void> _onFetchDogs(
    FetchDogsRequested event,
    Emitter<DogsState> emit,
  ) async {
    emit(const DogsLoading());
    final result = await getDogs(NoParams());
    result.fold(
      (failure) => emit(DogsError(failure.message)),
      (dogs) => emit(DogsLoaded(dogs: dogs, filteredDogs: dogs)),
    );
  }

  Future<void> _onAddDog(AddDogRequested event, Emitter<DogsState> emit) async {
    if (state is DogsLoaded) {
      final currentState = state as DogsLoaded;
      final result = await registerDog(event.dog);
      result.fold((failure) => emit(DogsError(failure.message)), (newDog) {
        final updatedDogs = List<Dog>.from(currentState.dogs)
          ..insert(0, newDog);
        emit(_applyFilters(currentState.copyWith(dogs: updatedDogs)));
      });
    }
  }

  Future<void> _onDeleteDog(
    DeleteDogRequested event,
    Emitter<DogsState> emit,
  ) async {
    if (state is DogsLoaded) {
      final currentState = state as DogsLoaded;
      final result = await deleteDog(event.dogId);
      result.fold((failure) => emit(DogsError(failure.message)), (_) {
        final updatedDogs = currentState.dogs
            .where((d) => d.id != event.dogId)
            .toList();
        emit(_applyFilters(currentState.copyWith(dogs: updatedDogs)));
      });
    }
  }

  void _onSearchQueryChanged(
    SearchDogsQueryChanged event,
    Emitter<DogsState> emit,
  ) {
    if (state is DogsLoaded) {
      final currentState = state as DogsLoaded;
      emit(_applyFilters(currentState.copyWith(searchQuery: event.query)));
    }
  }

  DogsLoaded _applyFilters(DogsLoaded loadedState) {
    final query = loadedState.searchQuery.toLowerCase();

    final filtered = loadedState.dogs.where((dog) {
      return dog.petName.toLowerCase().contains(query) ||
          dog.breed.toLowerCase().contains(query) ||
          dog.ownerName.toLowerCase().contains(query) ||
          dog.address.toLowerCase().contains(query) ||
          dog.id.toLowerCase().contains(query);
    }).toList();

    return loadedState.copyWith(filteredDogs: filtered);
  }
}
