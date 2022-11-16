import 'package:flutter/material.dart';
import 'package:scrolling_years_calendar/utils/constants.dart';

abstract class AbstractDayWidget extends StatelessWidget {
  const AbstractDayWidget({
    required this.dayDecorationBuilder,
    required this.dayStyleBuilder,
    super.key,
  });

  final DecorationWidgetBuilder dayDecorationBuilder;
  final TextStyleBuilder dayStyleBuilder;
}

abstract class AbstractDayTitleWidget extends StatelessWidget {
  const AbstractDayTitleWidget({
    required this.dayTitleDecorationBuilder,
    required this.dayTitleStyleBuilder,
    super.key,
  });

  final DecorationWidgetBuilder dayTitleDecorationBuilder;
  final TextStyleBuilder dayTitleStyleBuilder;
}

abstract class AbstractMonthWidget extends StatelessWidget {
  const AbstractMonthWidget({
    required this.dayDecorationBuilder,
    required this.dayStyleBuilder,
    required this.dayTitles,
    required this.dayTitleDecorationBuilder,
    required this.dayTitleStyleBuilder,
    required this.monthTitles,
    required this.monthTitleStyleBuilder,
    required this.monthDecorationBuilder,
    required this.showDayTitle,
    required this.startWeekWithSunday,
    super.key,
  });

  final List<String> dayTitles;
  final DecorationWidgetBuilder dayTitleDecorationBuilder;
  final TextStyleBuilder dayTitleStyleBuilder;
  final DecorationWidgetBuilder dayDecorationBuilder;
  final TextStyleBuilder dayStyleBuilder;
  final List<String> monthTitles;
  final TextStyleBuilder monthTitleStyleBuilder;
  final DecorationWidgetBuilder monthDecorationBuilder;
  final bool showDayTitle;
  final bool startWeekWithSunday;
}

abstract class AbstractYearWidget extends AbstractMonthWidget {
  const AbstractYearWidget({
    required this.monthsPerRow,
    required this.yearDecorationBuilder,
    required this.yearTitleStyleBuilder,
    required super.dayDecorationBuilder,
    required super.dayStyleBuilder,
    required super.dayTitles,
    required super.dayTitleDecorationBuilder,
    required super.dayTitleStyleBuilder,
    required super.monthTitles,
    required super.monthTitleStyleBuilder,
    required super.monthDecorationBuilder,
    required super.showDayTitle,
    required super.startWeekWithSunday,
    super.key,
  });

  final int monthsPerRow;
  final TextStyleBuilder yearTitleStyleBuilder;
  final DecorationWidgetBuilder yearDecorationBuilder;
}
