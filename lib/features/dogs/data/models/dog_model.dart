import '../../domain/entities/dog.dart';

class DogModel extends Dog {
  const DogModel({
    required super.id,
    super.photoUrl,
    required super.petName,
    required super.species,
    required super.breed,
    required super.birthdate,
    required super.sex,
    required super.ownerName,
    required super.address,
    required super.contactNumber,
    required super.registeredAt,
  });

  factory DogModel.fromJson(Map<String, dynamic> json) {
    return DogModel(
      id: json['id'] as String,
      photoUrl: json['photoUrl'] as String?,
      petName: json['petName'] as String,
      species: json['species'] as String? ?? 'Dog',
      breed: json['breed'] as String,
      birthdate: DateTime.parse(json['birthdate'] as String),
      sex: DogSex.values.byName(json['sex'] as String),
      ownerName: json['ownerName'] as String,
      address: json['address'] as String,
      contactNumber: json['contactNumber'] as String,
      registeredAt: DateTime.parse(json['registeredAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'photoUrl': photoUrl,
      'petName': petName,
      'species': species,
      'breed': breed,
      'birthdate': birthdate.toIso8601String(),
      'sex': sex.name,
      'ownerName': ownerName,
      'address': address,
      'contactNumber': contactNumber,
      'registeredAt': registeredAt.toIso8601String(),
    };
  }

  factory DogModel.fromEntity(Dog dog) {
    return DogModel(
      id: dog.id,
      photoUrl: dog.photoUrl,
      petName: dog.petName,
      species: dog.species,
      breed: dog.breed,
      birthdate: dog.birthdate,
      sex: dog.sex,
      ownerName: dog.ownerName,
      address: dog.address,
      contactNumber: dog.contactNumber,
      registeredAt: dog.registeredAt,
    );
  }
}
