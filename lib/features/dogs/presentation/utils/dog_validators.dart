abstract final class DogValidators {
  static String? Function(String?) required(String fieldName) {
    return (value) {
      if (value == null || value.trim().isEmpty) {
        return '$fieldName is required';
      }
      return null;
    };
  }

  /// Accepts +63 9XX XXX XXXX or 09XX XXX XXXX (spaces, dashes, brackets ignored).
  static String? phone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Contact number is required';
    }
    final digits = value.replaceAll(RegExp(r'[\s\-()]'), '');
    if (!RegExp(r'^(\+63|0)9\d{9}$').hasMatch(digits)) {
      return 'Use a valid number, e.g. +63 917 123 4567';
    }
    return null;
  }
}
