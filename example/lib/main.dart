import 'package:flutter/material.dart';
import 'package:scrolling_years_calendar/paged_vertical_years_calendar.dart';

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
        // to prevent the data from being reset every time a user loads or
        // unloads this widget
        addAutomaticKeepAlives: true,

        dayDecorationBuilder: (context, date) {
          if (date.year == initialDate.year &&
              date.month == initialDate.month &&
              date.day == initialDate.day) {
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
          if (date.year == initialDate.year &&
              date.month == initialDate.month &&
              date.day == initialDate.day) {
            return TextStyle(color: Colors.white);
          }

          return TextStyle();
        },
        onMonthTap: (date) => print('Tapped ${date.toString()}'),
      ),
    );
  }
}
