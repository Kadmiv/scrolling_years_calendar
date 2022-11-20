import 'package:flutter/material.dart';
import 'package:scrolling_years_calendar/utils/dates.dart';
import 'package:scrolling_years_calendar/utils/interfaces.dart';
import 'package:scrolling_years_calendar/widgets/day/day_title.dart';
import 'package:scrolling_years_calendar/widgets/day/day_view.dart';
import 'package:scrolling_years_calendar/widgets/month/month_title.dart';

const kCellsCountWithoutWeekTitles = 7 * 6;
const kCellsCountWithWeekTitles = 7 * 7;

class MonthView extends AbstractMonthWidget {
  const MonthView({
    required this.date,
    required super.dayDecorationBuilder,
    required super.dayStyleBuilder,
    required super.dayTitles,
    required super.dayTitleDecorationBuilder,
    required super.dayTitleStyleBuilder,
    required super.monthTitles,
    required super.monthTitleStyleBuilder,
    required super.monthDecorationBuilder,
    required super.showWeekDayTitle,
    required super.startWeekWithSunday,
    this.onMonthTap,
    super.key,
  });

  final DateTime date;
  final Function(DateTime date)? onMonthTap;

  @override
  Widget build(BuildContext context) {
    final monthView = Container(
      margin: const EdgeInsets.all(4),
      alignment: Alignment.center,
      child: Column(
        children: <Widget>[
          AspectRatio(
            aspectRatio: 6,
            child: Align(
              alignment: Alignment.centerLeft,
              child: MonthTitle(
                month: super.monthTitles[date.month - 1],
                date: date,
                monthTitleStyleBuilder: super.monthTitleStyleBuilder,
                monthDecorationBuilder: super.monthDecorationBuilder,
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 2),
            child: buildMonthDays(context),
          ),
        ],
      ),
    );

    return InkWell(
      onTap: () => onMonthTap?.call(date),
      child: monthView,
    );
  }

  Widget buildMonthDays(BuildContext context) {
    final daysInMonth = getDaysInMonth(date);
    var firstWeekdayOfMonth = DateUtils.firstDayOffset(
      date.year,
      date.month,
      MaterialLocalizations.of(context),
    );

    if (super.startWeekWithSunday) {
      if (firstWeekdayOfMonth == 7) {
        firstWeekdayOfMonth = 0;
      }
    } else {
      if (firstWeekdayOfMonth == 0) {
        firstWeekdayOfMonth = 7;
      }
    }

    final cellsCount =
        showWeekDayTitle ? kCellsCountWithWeekTitles : kCellsCountWithoutWeekTitles;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 7),
      itemCount: cellsCount,
      itemBuilder: (BuildContext ctx, int index) {
        final difference = showWeekDayTitle ? 7 : 0;

        final day = index -
            firstWeekdayOfMonth -
            difference +
            (super.startWeekWithSunday ? 1 : 2);

        final dayDate = DateTime(
          date.year,
          date.month,
          day,
        );

        if (showWeekDayTitle && index < 7) {
          return DayTitle(
            day: super.dayTitles[index],
            date: dayDate,
            dayTitleDecorationBuilder: super.dayTitleDecorationBuilder,
            dayTitleStyleBuilder: super.dayTitleStyleBuilder,
          );
        }

        Widget dayWidget = const SizedBox();

        if (day > 0 && day <= daysInMonth) {
          dayWidget = DayView(
            date: dayDate,
            dayDecorationBuilder: super.dayDecorationBuilder,
            dayStyleBuilder: super.dayStyleBuilder,
          );
        }

        return dayWidget;
      },
    );
  }
}
