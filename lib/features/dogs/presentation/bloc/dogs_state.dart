part of 'dogs_bloc.dart';

abstract class DogsState extends Equatable {
  const DogsState();

  @override
  List<Object?> get props => [];
}

class DogsInitial extends DogsState {
  const DogsInitial();
}

class DogsLoading extends DogsState {
  const DogsLoading();
}

class DogsLoaded extends DogsState {
  final List<Dog> dogs;
  final List<Dog> filteredDogs;
  final String searchQuery;
  final Set<String> selectedDogIds;

  const DogsLoaded({
    required this.dogs,
    required this.filteredDogs,
    this.searchQuery = '',
    this.selectedDogIds = const {},
  });

  DogsLoaded copyWith({
    List<Dog>? dogs,
    List<Dog>? filteredDogs,
    String? searchQuery,
    Set<String>? selectedDogIds,
  }) {
    return DogsLoaded(
      dogs: dogs ?? this.dogs,
      filteredDogs: filteredDogs ?? this.filteredDogs,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedDogIds: selectedDogIds ?? this.selectedDogIds,
    );
  }

  @override
  List<Object?> get props => [dogs, filteredDogs, searchQuery, selectedDogIds];
}

class DogsError extends DogsState {
  final String message;
  const DogsError(this.message);

  @override
  List<Object?> get props => [message];
}
