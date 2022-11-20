import 'package:flutter/material.dart';
import 'package:scrolling_years_calendar/paged_vertical_years_calendar.dart';
import 'package:scrolling_years_calendar/utils/extentions.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Scrolling Years Calendar',
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  List<DateTime> getHighlightedDates() {
    return List<DateTime>.generate(
      10,
      (int index) => DateTime.now().add(Duration(days: 10 * (index + 1))),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    print(size.toString());

    final initialDate = DateTime.now();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Scrolling Calendar'),
      ),
      body: PagedVerticalYearsCalendar(
        initialDate: initialDate,
        minDate: DateTime.now().subtract(const Duration(days: 2 * 365)),
        maxDate: DateTime.now().add(const Duration(days: 2 * 365)),
        showDayTitle: true,
        // startWeekWithSunday: true,
        monthsPerRow: 3,
        dayDecorationBuilder: (context, date) {
          if (date.isSameDay(initialDate)) {
            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40),
                color: Theme.of(context).primaryColor,
              ),
            );
          }

          return null;
        },
        dayStyleBuilder: (context, date) {
          if (date.isSameDay(initialDate)) {
            return TextStyle(color: Colors.white);
          }

          return TextStyle();
        },
        dayTitleDecorationBuilder: (context, date) {
          if (date.weekday==6||date.weekday==7) {
            return Container(
              decoration: BoxDecoration(
                color: Color.fromRGBO(255, 132, 132, 0.8),
              ),
            );
          }

          return null;
        },
        dayTitleStyleBuilder: (context, date) {
          if (date.weekday==6||date.weekday==7) {
            return TextStyle(color: Colors.white);
          }

          return TextStyle();
        },
        monthDecorationBuilder: (context, date) {
          if (date.month >= 1 && date.month < 3 || date.month == 12) {
            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8),
                  topRight: Radius.circular(8),
                ),
                color: Colors.blueAccent,
              ),
            );
          }
          if (date.month >= 3 && date.month < 6) {
            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8),
                  topRight: Radius.circular(8),
                ),
                color: Colors.lightGreenAccent,
              ),
            );
          } else if (date.month >= 6 && date.month < 9) {
            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8),
                  topRight: Radius.circular(8),
                ),
                color: Colors.yellowAccent,
              ),
            );
          } else if (date.month >= 9 && date.month < 12) {
            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8),
                  topRight: Radius.circular(8),
                ),
                color: Colors.orangeAccent,
              ),
            );
          }

          return null;
        },
        monthTitleStyleBuilder: (context, date) {
          if ((date.month >= 1 && date.month < 3 ) ||
              (date.month >= 9 && date.month <= 12)) {
            return TextStyle(color: Colors.white);
          }

          return TextStyle();
        },
        onMonthTap: (date) => print('Tapped ${date.toString()}'),
      ),
    );
  }
}
