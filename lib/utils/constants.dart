import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

typedef DecorationWidgetBuilder = Widget? Function(
  BuildContext context,
  DateTime date,
);

final DecorationWidgetBuilder defaultDecorationWidgetBuilder = (context, date) {
  return const SizedBox();
};

typedef TextStyleBuilder = TextStyle Function(
  BuildContext context,
  DateTime date,
);

final TextStyleBuilder defaultTextStyleBuilder = (context, date) {
  return Theme.of(context).textTheme.bodyText1 ?? const TextStyle();
};

final defaultWeekDayFormatter = DateFormat('E');
final defaultMonthFormatter = DateFormat('MMM');
