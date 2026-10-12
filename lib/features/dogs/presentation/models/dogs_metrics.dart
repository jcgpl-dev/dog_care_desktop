import 'package:equatable/equatable.dart';

import '../../domain/entities/dog.dart';

class DogsMetrics extends Equatable {
  const DogsMetrics({
    required this.total,
    required this.male,
    required this.female,
    required this.owners,
    required this.registeredThisMonth,
    required this.registeredLastMonth,
  });

  factory DogsMetrics.from(List<Dog> dogs, {DateTime? now}) {
    final today = now ?? DateTime.now();
    // DateTime(year, 0) rolls back to December of the previous year.
    final last = DateTime(today.year, today.month - 1);

    int countIn(DateTime month) => dogs
        .where(
          (d) =>
              d.registeredAt.year == month.year &&
              d.registeredAt.month == month.month,
        )
        .length;

    return DogsMetrics(
      total: dogs.length,
      male: dogs.where((d) => d.sex == DogSex.male).length,
      female: dogs.where((d) => d.sex == DogSex.female).length,
      owners: dogs.map((d) => d.ownerName.trim().toLowerCase()).toSet().length,
      registeredThisMonth: countIn(today),
      registeredLastMonth: countIn(last),
    );
  }

  final int total;
  final int male;
  final int female;
  final int owners;
  final int registeredThisMonth;
  final int registeredLastMonth;

  @override
  List<Object?> get props => [
    total,
    male,
    female,
    owners,
    registeredThisMonth,
    registeredLastMonth,
  ];
}
