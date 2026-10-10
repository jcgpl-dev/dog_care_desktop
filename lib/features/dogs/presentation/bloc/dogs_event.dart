part of 'dogs_bloc.dart';

abstract class DogsEvent extends Equatable {
  const DogsEvent();

  @override
  List<Object?> get props => [];
}

class FetchDogsRequested extends DogsEvent {
  const FetchDogsRequested();
}

class AddDogRequested extends DogsEvent {
  final Dog dog;
  const AddDogRequested(this.dog);

  @override
  List<Object?> get props => [dog];
}

class DeleteDogRequested extends DogsEvent {
  final String dogId;
  const DeleteDogRequested(this.dogId);

  @override
  List<Object?> get props => [dogId];
}

class SearchDogsQueryChanged extends DogsEvent {
  final String query;
  const SearchDogsQueryChanged(this.query);

  @override
  List<Object?> get props => [query];
}

class ToggleDogSelection extends DogsEvent {
  final String dogId;
  const ToggleDogSelection(this.dogId);

  @override
  List<Object?> get props => [dogId];
}

class ToggleSelectAllDogs extends DogsEvent {
  const ToggleSelectAllDogs();
}

class ClearDogSelections extends DogsEvent {
  const ClearDogSelections();
}
