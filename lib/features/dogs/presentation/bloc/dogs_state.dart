part of 'dogs_bloc.dart';

abstract class DogsState {
  const DogsState();
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
  final String? selectedBarangay;

  const DogsLoaded({
    required this.dogs,
    required this.filteredDogs,
    this.searchQuery = '',
    this.selectedBarangay,
  });

  DogsLoaded copyWith({
    List<Dog>? dogs,
    List<Dog>? filteredDogs,
    String? searchQuery,
    String? selectedBarangay,
  }) {
    return DogsLoaded(
      dogs: dogs ?? this.dogs,
      filteredDogs: filteredDogs ?? this.filteredDogs,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedBarangay: selectedBarangay ?? this.selectedBarangay,
    );
  }
}

class DogsError extends DogsState {
  final String message;
  const DogsError(this.message);
}
