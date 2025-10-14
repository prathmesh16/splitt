extension DateTimeExtensions on DateTime {
  bool isSameMonth(DateTime date2) {
    return year == date2.year && month == date2.month;
  }
}
