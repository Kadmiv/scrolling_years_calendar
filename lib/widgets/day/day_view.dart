import 'package:flutter/material.dart';
import 'package:scrolling_years_calendar/utils/device_type_helper.dart';
import 'package:scrolling_years_calendar/utils/utils.dart';

class DayView extends StatelessWidget {
  const DayView({
    required this.day,
    this.decoration,
   required this.monthsPerRow,
    super.key,
  });

  final String day;
  final Decoration? decoration;
  final int monthsPerRow;

  @override
  Widget build(BuildContext context) {
    final fontSize = calculateFontSize(4, monthsPerRow);

    return Container(
      alignment: Alignment.center,
      decoration: decoration,
      padding: EdgeInsets.all(1),
      child: Text(
        day,
        style: TextStyle(fontSize: fontSize),
        textAlign: TextAlign.center,
        // minFontSize: 4,
        maxLines: 1,
        // overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
