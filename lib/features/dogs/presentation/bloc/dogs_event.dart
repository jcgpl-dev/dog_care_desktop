part of 'dogs_bloc.dart';

abstract class DogsEvent {
  const DogsEvent();
}

class FetchDogsRequested extends DogsEvent {
  const FetchDogsRequested();
}

class AddDogRequested extends DogsEvent {
  final Dog dog;
  const AddDogRequested(this.dog);
}

class DeleteDogRequested extends DogsEvent {
  final String dogId;
  const DeleteDogRequested(this.dogId);
}

class SearchDogsQueryChanged extends DogsEvent {
  final String query;
  const SearchDogsQueryChanged(this.query);
}

class FilterDogsByBarangayChanged extends DogsEvent {
  final String? barangay;
  const FilterDogsByBarangayChanged(this.barangay);
}
