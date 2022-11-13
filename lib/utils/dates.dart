/// Checks if the given date is equal to the current date.
bool isCurrentDate(DateTime date) {
  final now = DateTime.now();
  return date.isAtSameMomentAs(DateTime(now.year, now.month, now.day));
}

/// Checks if the given date is a highlighted date.
bool isHighlightedDate(DateTime date, List<DateTime> highlightedDates) {
  return highlightedDates.any((DateTime highlightedDate) =>
      date.isAtSameMomentAs(DateTime(
          highlightedDate.year, highlightedDate.month, highlightedDate.day)));
}

/// Gets the number of days for the given month,
/// by taking the next month on day 0 and getting the number of days.
int getDaysInMonth(DateTime date) {
  return date.month < DateTime.monthsPerYear
      ? DateTime(date.year, date.month + 1, 0).day
      : DateTime(date.year + 1, 1, 0).day;
}
