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
    required super.showDayTitle,
    required super.startWeekWithSunday,
    this.onMonthTap,
    super.key,
  });

  final DateTime date;
  final Function(DateTime date)? onMonthTap;

  @override
  Widget build(BuildContext context) {
    final monthView = Container(
      // decoration: monthDecorationBuilder.call(context, date),
      margin: const EdgeInsets.all(4),
      padding: const EdgeInsets.all(6),
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
            margin: const EdgeInsets.only(top: 8),
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
        showDayTitle ? kCellsCountWithWeekTitles : kCellsCountWithoutWeekTitles;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 7),
      itemCount: cellsCount,
      // padding: const EdgeInsets.all(20),
      itemBuilder: (BuildContext ctx, int index) {
        final difference = showDayTitle ? 7 : 0;

        final day = index -
            firstWeekdayOfMonth -
            difference +
            (super.startWeekWithSunday ? 1 : 2);

        final dayDate = DateTime(
          date.year,
          date.month,
          day,
        );

        if (dayDate.year == 2022 && dayDate.month == 5 && dayDate.day == 1) {
          print('');
        }

        if (dayDate.year == 2022 && dayDate.month == 8 && dayDate.day == 1) {
          print('');
        }

        if (showDayTitle && index < 7) {
          return DayTitle(
            day: super.dayTitles[index],
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
