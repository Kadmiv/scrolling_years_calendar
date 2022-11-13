import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

typedef DayWidgetBuilder = Widget Function(
  BuildContext context,
  DateTime date,
);

typedef DecorationBuilder = Decoration? Function(
  BuildContext context,
  DateTime date,
);

final DecorationBuilder defaultDayDecoration = (context, date) {
  return BoxDecoration(
    color: Theme.of(context).cardColor,
  );
};

final DecorationBuilder defaultMonthDecoration = (context, date) {
  return BoxDecoration(
    color: Theme.of(context).cardColor,
    borderRadius: BorderRadius.circular(8),
  );
};

final DecorationBuilder defaultYearDecoration = (context, date) {
  return BoxDecoration(
    color: Theme.of(context).cardColor,
  );
};

final defaultWeekDayFormatter = DateFormat('E');
final defaultMonthFormatter = DateFormat('MMM');
