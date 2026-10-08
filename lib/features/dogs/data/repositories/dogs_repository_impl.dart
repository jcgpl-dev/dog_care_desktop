import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/dog.dart';
import '../../domain/repositories/dogs_repository.dart';
import '../datasources/local/mock_dogs_datasource.dart';
import '../models/dog_model.dart';

class DogsRepositoryImpl implements DogsRepository {
  final DogsDataSource dataSource;

  DogsRepositoryImpl({required this.dataSource});

  @override
  Future<Either<Failure, List<Dog>>> getDogs() async {
    try {
      final dogs = await dataSource.getDogs();
      return Right(dogs);
    } catch (e) {
      return Left(ServerFailure(e.toString().replaceFirst('Exception: ', '')));
    }
  }

  @override
  Future<Either<Failure, Dog>> registerDog(Dog dog) async {
    try {
      final model = DogModel.fromEntity(dog);
      final result = await dataSource.registerDog(model);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString().replaceFirst('Exception: ', '')));
    }
  }

  @override
  Future<Either<Failure, Dog>> updateDog(Dog dog) async {
    try {
      final model = DogModel.fromEntity(dog);
      final result = await dataSource.updateDog(model);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString().replaceFirst('Exception: ', '')));
    }
  }

  @override
  Future<Either<Failure, void>> deleteDog(String id) async {
    try {
      await dataSource.deleteDog(id);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString().replaceFirst('Exception: ', '')));
    }
  }
}
