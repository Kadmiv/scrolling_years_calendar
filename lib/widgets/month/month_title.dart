import 'package:flutter/material.dart';
import 'package:scrolling_years_calendar/utils/device_type_helper.dart';
import 'package:scrolling_years_calendar/utils/utils.dart';

class MonthTitle extends StatelessWidget {
  const MonthTitle({
    required this.month,
    this.style = const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w600,
    ),
    required this.monthsPerRow,
    super.key,
  });

  final String month;
  final TextStyle? style;
  final int monthsPerRow;

  @override
  Widget build(BuildContext context) {
    final fontSize = calculateFontSize(10, monthsPerRow);

    return Container(
      child: Text(
        month,
        maxLines: 1,
        style: TextStyle(fontSize: fontSize),
      ),
    );
  }
}
