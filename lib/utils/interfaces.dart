import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:scrolling_years_calendar/utils/constants.dart';

abstract class AbstractDayWidget extends StatelessWidget {
  const AbstractDayWidget({
    required this.dayBuilder,
    required this.dayTitleDecoration,

    required this.monthsPerRow,
    super.key,
  });

  final DayWidgetBuilder dayBuilder;
  final DecorationBuilder dayTitleDecoration;
  final int monthsPerRow;

}

abstract class AbstractMonthWidget extends AbstractDayWidget {
  const AbstractMonthWidget({
    required this.monthDecoration,
    required this.monthTitles,
    required this.weekDayFormatter,
    required this.daysWidgets,
    required this.showDayTitle,
    required this.startWeekWithSunday,
    required this.uniqueDates,
    required super.dayBuilder,
    required super.dayTitleDecoration,
    required super.monthsPerRow,
    super.key,
  });

  final DecorationBuilder monthDecoration;
  final List<String> monthTitles;
  final List<Widget> daysWidgets;
  final Map<String, DateTime> uniqueDates;
  final bool showDayTitle;
  final bool startWeekWithSunday;
  final DateFormat weekDayFormatter;
}

abstract class AbstractYearWidget extends AbstractMonthWidget {
  const AbstractYearWidget({
    required this.yearDecoration,
    required super.dayBuilder,
    required super.daysWidgets,
    required super.showDayTitle,
    required super.uniqueDates,
    required super.startWeekWithSunday,
    required super.monthDecoration,
    required super.monthTitles,
    required super.weekDayFormatter,
    required super.dayTitleDecoration,
    required super.monthsPerRow,
    super.key,
  });

  final DecorationBuilder yearDecoration;
}
