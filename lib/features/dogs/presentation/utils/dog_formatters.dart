import 'package:intl/intl.dart';

import '../../domain/entities/dog.dart';

abstract final class DogFormatters {
  static String date(DateTime value) => DateFormat('MMM d, yyyy').format(value);

  static String sexLabel(DogSex sex) =>
      sex == DogSex.male ? 'Male' : 'Female';

  /// "3 mo", "2 yr", "2 yr 6 mo". Humans read age, not ISO dates.
  static String age(DateTime birthdate, {DateTime? now}) {
    final today = now ?? DateTime.now();
    var months =
        (today.year - birthdate.year) * 12 + today.month - birthdate.month;
    if (today.day < birthdate.day) months--;
    if (months < 1) return '< 1 mo';

    final years = months ~/ 12;
    final rest = months % 12;
    if (years == 0) return '$rest mo';
    if (rest == 0) return '$years yr';
    return '$years yr $rest mo';
  }
}
