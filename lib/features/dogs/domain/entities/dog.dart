import 'package:equatable/equatable.dart';

enum DogGender { male, female }

enum DogStatus { healthy, atRisk, critical }

class Dog extends Equatable {
  final String id;
  final String name;
  final String breed;
  final String color;
  final String ownerName;
  final String ownerContact;
  final String barangay; // Katipunan Barangay locality
  final int ageYears;
  final double weightKg;
  final DogGender gender;
  final DogStatus status;
  final bool isVaccinated;
  final String? avatarUrl;
  final DateTime registeredAt;

  const Dog({
    required this.id,
    required this.name,
    required this.breed,
    required this.color,
    required this.ownerName,
    required this.ownerContact,
    required this.barangay,
    required this.ageYears,
    required this.weightKg,
    required this.gender,
    required this.status,
    required this.isVaccinated,
    this.avatarUrl,
    required this.registeredAt,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    breed,
    color,
    ownerName,
    ownerContact,
    barangay,
    ageYears,
    weightKg,
    gender,
    status,
    isVaccinated,
    avatarUrl,
    registeredAt,
  ];
}
