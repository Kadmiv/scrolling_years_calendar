extension DateUtilsExtensions on DateTime {
  DateTime get nextDay => DateTime(year, month, day + 1);

  bool isSameDayOrAfter(DateTime other) => isAfter(other) || isSameDay(other);

  bool isSameDayOrBefore(DateTime other) => isBefore(other) || isSameDay(other);

  bool isSameDay(DateTime other) =>
      year == other.year && month == other.month && day == other.day;

  DateTime removeTime() => DateTime(year, month, day);

  bool isSameMonth(DateTime other) =>
      other.year == year && other.month == month;

  bool isSameYear(DateTime other) => other.year == year;
}
