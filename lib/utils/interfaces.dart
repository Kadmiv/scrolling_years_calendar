import 'package:flutter/material.dart';
import 'package:scrolling_years_calendar/utils/constants.dart';

abstract class AbstractDayWidget extends StatelessWidget {
  const AbstractDayWidget({
    required this.dayBuilder,
    required this.dayTitleDecoration,
    super.key,
  });

  final DayWidgetBuilder dayBuilder;
  final DecorationBuilder dayTitleDecoration;
}

abstract class AbstractMonthWidget extends AbstractDayWidget {
  const AbstractMonthWidget({
    required this.monthDecoration,
    required this.dayTitles,
    required this.monthTitles,
    required this.showDayTitle,
    required this.startWeekWithSunday,
    required this.uniqueDates,
    required super.dayBuilder,
    required super.dayTitleDecoration,
    super.key,
  });

  final DecorationBuilder monthDecoration;
  final List<String> monthTitles;
  final List<String> dayTitles;
  final Map<String, DateTime> uniqueDates;
  final bool showDayTitle;
  final bool startWeekWithSunday;
}

abstract class AbstractYearWidget extends AbstractMonthWidget {
  const AbstractYearWidget({
    required this.monthsPerRow,
    required this.yearDecoration,
    required super.dayBuilder,
    required super.showDayTitle,
    required super.uniqueDates,
    required super.startWeekWithSunday,
    required super.monthDecoration,
    required super.dayTitles,
    required super.monthTitles,
    required super.dayTitleDecoration,
    super.key,
  });

  final int monthsPerRow;
  final DecorationBuilder yearDecoration;
}
