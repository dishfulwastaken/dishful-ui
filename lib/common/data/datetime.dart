import 'package:intl/intl.dart';

extension DateTimeExtension on DateTime {
  bool get isAfterNow => this.isAfter(DateTime.now());

  String get formatted {
    final formatter = DateFormat.yMMMMEEEEd();
    return formatter.format(this);
  }
}
