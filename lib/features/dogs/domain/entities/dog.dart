import 'package:equatable/equatable.dart';

enum DogSex { male, female }

class Dog extends Equatable {
  final String id;
  final String? photoUrl;
  final String petName;
  final String breed;
  final DateTime birthdate;
  final DogSex sex;
  final String ownerName;
  final String address;
  final String contactNumber;
  final DateTime registeredAt;

  const Dog({
    required this.id,
    this.photoUrl,
    required this.petName,
    required this.breed,
    required this.birthdate,
    required this.sex,
    required this.ownerName,
    required this.address,
    required this.contactNumber,
    required this.registeredAt,
  });

  @override
  List<Object?> get props => [
    id,
    photoUrl,
    petName,
    breed,
    birthdate,
    sex,
    ownerName,
    address,
    contactNumber,
    registeredAt,
  ];
}
