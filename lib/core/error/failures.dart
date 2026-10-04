abstract class Failure {
  final String message;
  const Failure([this.message = 'An unexpected error occurred.']);
}

class ServerFailure extends Failure {
  const ServerFailure([super.message = 'Server connection failed.']);
}

class CacheFailure extends Failure {
  const CacheFailure([super.message = 'Local cache data operation failed.']);
}
