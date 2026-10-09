import '../../models/dog_model.dart';
import '../../../domain/entities/dog.dart';

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
      photoUrl: null,
      petName: 'Bruno',
      species: 'Dog',
      breed: 'Askal / Aspin',
      birthdate: DateTime(2023, 4, 12),
      sex: DogSex.male,
      ownerName: 'Juan Dela Cruz',
      address: 'Poblacion, Zamboanga City',
      contactNumber: '+63 917 123 4567',
      registeredAt: DateTime(2026, 1, 15),
    ),
    DogModel(
      id: 'DOG-2026-002',
      photoUrl: null,
      petName: 'Max',
      species: 'Dog',
      breed: 'German Shepherd',
      birthdate: DateTime(2024, 2, 20),
      sex: DogSex.male,
      ownerName: 'Maria Santos',
      address: 'Tetuan, Zamboanga City',
      contactNumber: '+63 918 234 5678',
      registeredAt: DateTime(2026, 2, 10),
    ),
    DogModel(
      id: 'DOG-2026-003',
      photoUrl: null,
      petName: 'Lucky',
      species: 'Dog',
      breed: 'Shih Tzu',
      birthdate: DateTime(2025, 1, 10),
      sex: DogSex.female,
      ownerName: 'Ana Reyes',
      address: 'San Jose, Zamboanga City',
      contactNumber: '+63 919 345 6789',
      registeredAt: DateTime(2026, 3, 1),
    ),
  ];

  @override
  Future<List<DogModel>> getDogs() async {
    await Future.delayed(const Duration(milliseconds: 400));
    return List.from(_mockDogs);
  }

  @override
  Future<DogModel> registerDog(DogModel dog) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _mockDogs.insert(0, dog);
    return dog;
  }

  @override
  Future<DogModel> updateDog(DogModel dog) async {
    await Future.delayed(const Duration(milliseconds: 300));
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
