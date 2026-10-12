import 'package:dartz/dartz.dart';
import 'package:dog_care_desktop/features/dogs/domain/repositories/dogs_repository.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/dog.dart';

/// NEW use case. Edits previously went through [RegisterDog], which inserted
/// a duplicate row. Adjust the imports (dartz/fpdart, Failure path,
/// repository name) to match your project.
class UpdateDog implements UseCase<Dog, Dog> {
  final DogsRepository repository;

  const UpdateDog(this.repository);

  @override
  Future<Either<Failure, Dog>> call(Dog dog) => repository.updateDog(dog);
}
