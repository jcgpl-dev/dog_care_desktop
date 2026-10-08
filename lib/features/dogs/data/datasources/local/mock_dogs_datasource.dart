import 'package:dog_care_desktop/features/dogs/domain/entities/dog.dart';

import '../../models/dog_model.dart';

abstract class DogsDataSource {
  Future<List<DogModel>> getDogs();
  Future<DogModel> registerDog(DogModel dog);
  Future<DogModel> updateDog(DogModel dog);
  Future<void> deleteDog(String id);
}

class MockDogsDataSource implements DogsDataSource {
  final List<DogModel> _mockDogs = [
    DogModel(
      id: 'DOG-2026-001',
      name: 'Bruno',
      breed: 'Askal / Aspin',
      color: 'Brown & White',
      ownerName: 'Juan Dela Cruz',
      ownerContact: '+63 917 123 4567',
      barangay: 'Uno (Poblacion)',
      ageYears: 3,
      weightKg: 14.5,
      gender: DogGender.male,
      status: DogStatus.healthy,
      isVaccinated: true,
      registeredAt: DateTime(2026, 1, 15),
    ),
    DogModel(
      id: 'DOG-2026-002',
      name: 'Max',
      breed: 'German Shepherd',
      color: 'Black & Tan',
      ownerName: 'Maria Santos',
      ownerContact: '+63 918 234 5678',
      barangay: 'Dos (Poblacion)',
      ageYears: 2,
      weightKg: 28.0,
      gender: DogGender.male,
      status: DogStatus.healthy,
      isVaccinated: true,
      registeredAt: DateTime(2026, 2, 10),
    ),
    DogModel(
      id: 'DOG-2026-003',
      name: 'Lucky',
      breed: 'Shih Tzu',
      color: 'White & Gold',
      ownerName: 'Ana Reyes',
      ownerContact: '+63 919 345 6789',
      barangay: 'San Antonio',
      ageYears: 1,
      weightKg: 5.2,
      gender: DogGender.female,
      status: DogStatus.healthy,
      isVaccinated: false,
      registeredAt: DateTime(2026, 3, 01),
    ),
    DogModel(
      id: 'DOG-2026-004',
      name: 'Rocky',
      breed: 'Labrador Retriever',
      color: 'Yellow',
      ownerName: 'Mark Mendoza',
      ownerContact: '+63 920 456 7890',
      barangay: 'Matam',
      ageYears: 4,
      weightKg: 30.1,
      gender: DogGender.male,
      status: DogStatus.atRisk,
      isVaccinated: false,
      registeredAt: DateTime(2026, 3, 12),
    ),
    DogModel(
      id: 'DOG-2026-005',
      name: 'Choco',
      breed: 'Askal / Aspin',
      color: 'Dark Brown',
      ownerName: 'Elena Garcia',
      ownerContact: '+63 921 567 8901',
      barangay: 'Matingao',
      ageYears: 2,
      weightKg: 12.0,
      gender: DogGender.female,
      status: DogStatus.healthy,
      isVaccinated: true,
      registeredAt: DateTime(2026, 4, 05),
    ),
  ];

  @override
  Future<List<DogModel>> getDogs() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return List.from(_mockDogs);
  }

  @override
  Future<DogModel> registerDog(DogModel dog) async {
    await Future.delayed(const Duration(milliseconds: 400));
    _mockDogs.insert(0, dog);
    return dog;
  }

  @override
  Future<DogModel> updateDog(DogModel dog) async {
    await Future.delayed(const Duration(milliseconds: 400));
    final index = _mockDogs.indexWhere((d) => d.id == dog.id);
    if (index != -1) {
      _mockDogs[index] = dog;
    }
    return dog;
  }

  @override
  Future<void> deleteDog(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _mockDogs.removeWhere((d) => d.id == id);
  }
}
