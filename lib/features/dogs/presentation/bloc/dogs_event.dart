part of 'dogs_bloc.dart';

sealed class DogsEvent extends Equatable {
  const DogsEvent();

  @override
  List<Object?> get props => [];
}

// ── Data ────────────────────────────────────────────────────────────────
class FetchDogsRequested extends DogsEvent {
  const FetchDogsRequested();
}

class AddDogRequested extends DogsEvent {
  const AddDogRequested(this.dog);
  final Dog dog;

  @override
  List<Object?> get props => [dog];
}

class UpdateDogRequested extends DogsEvent {
  const UpdateDogRequested(this.dog);
  final Dog dog;

  @override
  List<Object?> get props => [dog];
}

class DeleteDogRequested extends DogsEvent {
  const DeleteDogRequested(this.dogId);
  final String dogId;

  @override
  List<Object?> get props => [dogId];
}

/// Deletes everything currently selected as ONE event (one rebuild, one toast).
class DeleteSelectedDogsRequested extends DogsEvent {
  const DeleteSelectedDogsRequested();
}

// ── Query (search / filter / sort / paging) ─────────────────────────────
class SearchDogsQueryChanged extends DogsEvent {
  const SearchDogsQueryChanged(this.query);
  final String query;

  @override
  List<Object?> get props => [query];
}

class DogsSexFilterChanged extends DogsEvent {
  const DogsSexFilterChanged(this.filter);
  final DogSexFilter filter;

  @override
  List<Object?> get props => [filter];
}

class DogsSortChanged extends DogsEvent {
  const DogsSortChanged(this.field);
  final DogSortField field;

  @override
  List<Object?> get props => [field];
}

class DogsPageChanged extends DogsEvent {
  const DogsPageChanged(this.page);
  final int page;

  @override
  List<Object?> get props => [page];
}

// ── Selection ───────────────────────────────────────────────────────────
class ToggleDogSelection extends DogsEvent {
  const ToggleDogSelection(this.dogId);
  final String dogId;

  @override
  List<Object?> get props => [dogId];
}

/// Selects / deselects every row on the CURRENT page.
class ToggleSelectAllDogs extends DogsEvent {
  const ToggleSelectAllDogs();
}

class ClearDogSelections extends DogsEvent {
  const ClearDogSelections();
}
