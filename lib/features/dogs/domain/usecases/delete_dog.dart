import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/dogs_repository.dart';

class DeleteDog implements UseCase<void, String> {
  final DogsRepository repository;

  DeleteDog(this.repository);

  @override
  Future<Either<Failure, void>> call(String id) {
    return repository.deleteDog(id);
  }
}
