import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/dog.dart';
import '../repositories/dogs_repository.dart';

class RegisterDog implements UseCase<Dog, Dog> {
  final DogsRepository repository;

  RegisterDog(this.repository);

  @override
  Future<Either<Failure, Dog>> call(Dog dog) {
    return repository.registerDog(dog);
  }
}
