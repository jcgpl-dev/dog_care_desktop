import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/dog.dart';
import '../repositories/dogs_repository.dart';

class GetDogs implements UseCase<List<Dog>, NoParams> {
  final DogsRepository repository;

  GetDogs(this.repository);

  @override
  Future<Either<Failure, List<Dog>>> call(NoParams params) {
    return repository.getDogs();
  }
}
