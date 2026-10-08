import '../../domain/entities/dog.dart';

class DogModel extends Dog {
  const DogModel({
    required super.id,
    required super.name,
    required super.breed,
    required super.color,
    required super.ownerName,
    required super.ownerContact,
    required super.barangay,
    required super.ageYears,
    required super.weightKg,
    required super.gender,
    required super.status,
    required super.isVaccinated,
    super.avatarUrl,
    required super.registeredAt,
  });

  factory DogModel.fromJson(Map<String, dynamic> json) {
    return DogModel(
      id: json['id'] as String,
      name: json['name'] as String,
      breed: json['breed'] as String,
      color: json['color'] as String,
      ownerName: json['ownerName'] as String,
      ownerContact: json['ownerContact'] as String,
      barangay: json['barangay'] as String,
      ageYears: json['ageYears'] as int,
      weightKg: (json['weightKg'] as num).toDouble(),
      gender: DogGender.values.byName(json['gender'] as String),
      status: DogStatus.values.byName(json['status'] as String),
      isVaccinated: json['isVaccinated'] as bool? ?? false,
      avatarUrl: json['avatarUrl'] as String?,
      registeredAt: DateTime.parse(json['registeredAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'breed': breed,
      'color': color,
      'ownerName': ownerName,
      'ownerContact': ownerContact,
      'barangay': barangay,
      'ageYears': ageYears,
      'weightKg': weightKg,
      'gender': gender.name,
      'status': status.name,
      'isVaccinated': isVaccinated,
      'avatarUrl': avatarUrl,
      'registeredAt': registeredAt.toIso8601String(),
    };
  }

  factory DogModel.fromEntity(Dog dog) {
    return DogModel(
      id: dog.id,
      name: dog.name,
      breed: dog.breed,
      color: dog.color,
      ownerName: dog.ownerName,
      ownerContact: dog.ownerContact,
      barangay: dog.barangay,
      ageYears: dog.ageYears,
      weightKg: dog.weightKg,
      gender: dog.gender,
      status: dog.status,
      isVaccinated: dog.isVaccinated,
      avatarUrl: dog.avatarUrl,
      registeredAt: dog.registeredAt,
    );
  }
}
