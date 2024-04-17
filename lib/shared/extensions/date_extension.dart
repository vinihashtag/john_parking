import 'package:intl/intl.dart';

extension DateTimeUtils on DateTime {
  String get formatddMMyyyyHHmmss => DateFormat('dd/MM/yyyy HH:mm:ss').format(this);

  String get formatddMMyyyyHHmm => DateFormat('dd/MM/yyyy HH:mm').format(this);

  String get formatddMMyyyy => DateFormat('dd/MM/yyyy').format(this);

  String get formatHHmm => DateFormat('HH:mm').format(this);

  bool equals(DateTime otherDate, {bool onlyDate = false}) {
    if (onlyDate) {
      return year == otherDate.year && month == otherDate.month && day == otherDate.day;
    } else {
      return year == otherDate.year &&
          month == otherDate.month &&
          day == otherDate.day &&
          hour == otherDate.hour &&
          minute == otherDate.minute;
    }
  }
}
