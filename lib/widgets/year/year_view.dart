import 'package:flutter/material.dart';
import 'package:scrolling_years_calendar/utils/interfaces.dart';
import 'package:scrolling_years_calendar/widgets/month/month_view.dart';
import 'package:scrolling_years_calendar/widgets/year/year_title.dart';

class YearView extends AbstractYearWidget {
  const YearView({
    required this.date,
    required super.showDayTitle,
    required super.uniqueDates,
    required super.startWeekWithSunday,
    required super.dayBuilder,
    required super.dayTitleDecoration,
    required super.monthDecoration,
    required super.monthTitles,
    required super.dayTitles,
    required super.yearDecoration,
    required super.monthsPerRow,
    this.onMonthTap,
    this.monthTitleStyle,
    super.key,
  });

  final DateTime date;
  final Function(DateTime dateTime)? onMonthTap;
  final TextStyle? monthTitleStyle;

  @override
  Widget build(BuildContext context) {

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          AspectRatio(
            aspectRatio: 10,
            child: Align(
              alignment: Alignment.centerLeft,
              child: YearTitle(date),
            ),
          ),
          buildYearMonths(context),
        ],
      ),
    );
  }

  Widget buildYearMonths(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        childAspectRatio: showDayTitle ? 0.9 : 1.0,
        crossAxisCount: monthsPerRow,
      ),
      itemCount: 12,
      // padding: const EdgeInsets.all(20),
      itemBuilder: (BuildContext ctx, int index) {
        final date = DateTime(this.date.year, index + 1);

        return MonthView(
          date: date,
          monthTitles: super.monthTitles,
          uniqueDates: super.uniqueDates,
          dayTitles: super.dayTitles,
          onMonthTap: onMonthTap,
          titleStyle: monthTitleStyle,
          showDayTitle: showDayTitle,
          startWeekWithSunday: startWeekWithSunday,
          dayBuilder: super.dayBuilder,
          dayTitleDecoration: super.dayTitleDecoration,
          monthDecoration: super.monthDecoration,
        );
      },
    );
  }
}
