import 'package:flutter/material.dart';
import 'package:scrolling_years_calendar/utils/dates.dart';
import 'package:scrolling_years_calendar/utils/interfaces.dart';
import 'package:scrolling_years_calendar/widgets/day/day_number.dart';
import 'package:scrolling_years_calendar/widgets/month/month_title.dart';

const kCellsCountWithoutWeekTitles = 35;
const kCellsCountWithWeekTitles = 42;

class MonthView extends AbstractMonthWidget {
  const MonthView({
    required this.date,
    required super.monthDecoration,
    required super.monthTitles,
    required super.uniqueDates,
    required super.weekDayFormatter,
    required super.dayBuilder,
    required super.daysWidgets,
    required super.dayTitleDecoration,
    required super.showDayTitle,
    required super.startWeekWithSunday,
    this.onMonthTap,
    this.titleStyle,
    super.key,
  });

  final DateTime date;
  final Function(DateTime date)? onMonthTap;
  final TextStyle? titleStyle;

  @override
  Widget build(BuildContext context) {
    final monthView = Container(
      decoration: monthDecoration.call(context, date),
      margin: const EdgeInsets.all(4),
      padding: const EdgeInsets.all(6),
      alignment: Alignment.center,
      child: Column(
        children: <Widget>[
          AspectRatio(
            aspectRatio: 7,
            child: MonthTitle(
              month: super.monthTitles[date.month-1],
              style: titleStyle,
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
    var firstWeekdayOfMonth = DateTime(date.year, date.month).weekday;
    if (firstWeekdayOfMonth == 7) {
      firstWeekdayOfMonth = 0;
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

        final day = 1 + index - firstWeekdayOfMonth - difference;
        final dayDate = DateTime(
          date.year,
          date.month,
          day,
        );

        if (showDayTitle && index < 7) {
          return DayNumber(
            day: weekDayFormatter.format(dayDate),
            decoration: dayTitleDecoration(context, dayDate),
          );
        }

        Widget dayWidget = const SizedBox();

        if (day > 0 && day <= daysInMonth) {
          if(uniqueDates.containsKey(dayDate.toString())){
            dayWidget = dayBuilder(context, dayDate);
          }
          else{
            dayWidget = super.daysWidgets[day-1];
          }
        }

        return dayWidget;
      },
    );
  }
}
