import 'package:equatable/equatable.dart';

import '../../domain/entities/dog.dart';

enum DogSexFilter { all, male, female }

enum DogSortField { id, petName, breed, age, sex, ownerName, registeredAt }

class DogsQuery extends Equatable {
  const DogsQuery({
    this.search = '',
    this.sexFilter = DogSexFilter.all,
    this.sortField = DogSortField.registeredAt,
    this.ascending = false,
  });

  final String search;
  final DogSexFilter sexFilter;
  final DogSortField sortField;
  final bool ascending;

  bool get isFiltering =>
      search.trim().isNotEmpty || sexFilter != DogSexFilter.all;

  DogsQuery copyWith({
    String? search,
    DogSexFilter? sexFilter,
    DogSortField? sortField,
    bool? ascending,
  }) {
    return DogsQuery(
      search: search ?? this.search,
      sexFilter: sexFilter ?? this.sexFilter,
      sortField: sortField ?? this.sortField,
      ascending: ascending ?? this.ascending,
    );
  }

  List<Dog> apply(List<Dog> dogs) {
    final needle = search.trim().toLowerCase();
    final result = dogs
        .where((dog) => _matchesSex(dog) && _matchesSearch(dog, needle))
        .toList();
    result.sort(_compare);
    return result;
  }

  bool _matchesSex(Dog dog) => switch (sexFilter) {
    DogSexFilter.all => true,
    DogSexFilter.male => dog.sex == DogSex.male,
    DogSexFilter.female => dog.sex == DogSex.female,
  };

  bool _matchesSearch(Dog dog, String needle) {
    if (needle.isEmpty) return true;
    return [
      dog.id,
      dog.petName,
      dog.breed,
      dog.ownerName,
      dog.address,
      dog.contactNumber,
      
    ].any((field) => field.toLowerCase().contains(needle));
  }

  int _compare(Dog a, Dog b) {
    final result = switch (sortField) {
      DogSortField.id => _text(a.id, b.id),
      DogSortField.petName => _text(a.petName, b.petName),
      DogSortField.breed => _text(a.breed, b.breed),
      // Ascending age = youngest first, so the comparison is inverted.
      DogSortField.age => b.birthdate.compareTo(a.birthdate),
      DogSortField.sex => a.sex.index.compareTo(b.sex.index),
      DogSortField.ownerName => _text(a.ownerName, b.ownerName),
      DogSortField.registeredAt => a.registeredAt.compareTo(b.registeredAt),
    };
    return ascending ? result : -result;
  }

  static int _text(String a, String b) =>
      a.toLowerCase().compareTo(b.toLowerCase());

  @override
  List<Object?> get props => [search, sexFilter, sortField, ascending];
}
