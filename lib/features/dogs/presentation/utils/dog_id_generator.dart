/// TEMPORARY: IDs should be assigned by the repository / backend.
/// Kept out of the form widget so it can be deleted in one place later.
abstract final class DogIdGenerator {
  static String next() {
    final now = DateTime.now();
    final suffix = (now.microsecondsSinceEpoch % 1000000)
        .toString()
        .padLeft(6, '0');
    return 'DOG-${now.year}-$suffix';
  }
}
