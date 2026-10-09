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

  const DogsLoaded({
    required this.dogs,
    required this.filteredDogs,
    this.searchQuery = '',
  });

  DogsLoaded copyWith({
    List<Dog>? dogs,
    List<Dog>? filteredDogs,
    String? searchQuery,
  }) {
    return DogsLoaded(
      dogs: dogs ?? this.dogs,
      filteredDogs: filteredDogs ?? this.filteredDogs,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  @override
  List<Object?> get props => [dogs, filteredDogs, searchQuery];
}

class DogsError extends DogsState {
  final String message;
  const DogsError(this.message);

  @override
  List<Object?> get props => [message];
}
