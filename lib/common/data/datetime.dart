extension DateTimeExtension on DateTime {
  bool get isAfterNow => this.isAfter(DateTime.now());
}
