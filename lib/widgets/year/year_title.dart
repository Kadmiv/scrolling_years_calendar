import 'package:flutter/material.dart';
import 'package:scrolling_years_calendar/utils/device_type_helper.dart';
import 'package:scrolling_years_calendar/utils/utils.dart';

class YearTitle extends StatelessWidget {
  const YearTitle(this.date,  {required this.monthsPerRow,super.key});

  final DateTime date;
  final int monthsPerRow;

  @override
  Widget build(BuildContext context) {
    final fontSize = calculateFontSize(12, monthsPerRow);

    return Container(
      child: Text(
        date.year.toString(),
        style: TextStyle(fontSize: fontSize),
      ),
    );
  }
}

