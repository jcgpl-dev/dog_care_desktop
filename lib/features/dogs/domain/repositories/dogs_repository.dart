import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/dog.dart';

abstract class DogsRepository {
  Future<Either<Failure, List<Dog>>> getDogs();
  Future<Either<Failure, Dog>> registerDog(Dog dog);
  Future<Either<Failure, Dog>> updateDog(Dog dog);
  Future<Either<Failure, void>> deleteDog(String id);
}
