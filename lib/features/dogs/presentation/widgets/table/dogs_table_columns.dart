import '../../models/dogs_query.dart';

enum DogsTableColumn {
  // id('ID', 2, DogSortField.id),
  petName('Dog', 3, DogSortField.petName),
  breed('Breed', 3, DogSortField.breed),
  age('Age', 2, DogSortField.age),
  sex('Sex', 3, DogSortField.sex),
  owner('Owner', 3, DogSortField.ownerName),
  address('Address', 4, null),
  contact('Contact', 3, null);

  const DogsTableColumn(this.label, this.flex, this.sortField);

  final String label;
  final int flex;
  final DogSortField? sortField;
}

abstract final class DogsTableLayout {
  static const double checkboxWidth = 56;
  static const double actionsWidth = 64;
  static const double headerHeight = 48;
  static const double rowHeight = 56;
  static const double minWidth = 1040;
}
