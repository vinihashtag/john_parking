import 'package:intl/intl.dart';

extension DateTimeUtils on DateTime {
  String get formatddMMyyyyHHmmss => DateFormat('dd/MM/yyyy HH:mm:ss').format(this);

  String get formatddMMyyyy => DateFormat('dd/MM/yyyy').format(this);

  String get formatHHmm => DateFormat('HH:mm').format(this);
}
