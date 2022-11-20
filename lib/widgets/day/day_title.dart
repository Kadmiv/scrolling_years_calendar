import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:scrolling_years_calendar/utils/interfaces.dart';

class DayTitle extends AbstractDayTitleWidget {
  const DayTitle({
    required this.day,
    required this.date,
    required super.dayTitleDecorationBuilder,
    required super.dayTitleStyleBuilder,
    super.key,
  });

  final String day;
  final DateTime date;

  @override
  Widget build(BuildContext context) {
    final style = dayTitleStyleBuilder(context, date).copyWith(fontSize: 20);

    return LayoutBuilder(builder: (context, constraints) {
      return Container(
        padding: const EdgeInsets.all(1),
        child: Stack(
          alignment: Alignment.center,
          children: [
            dayTitleDecorationBuilder(context, date) ?? const SizedBox(),
            SizedBox(
              height: constraints.maxHeight / 2,
              child: AutoSizeText(
                day,
                style: style,
                textAlign: TextAlign.center,
                minFontSize: 4,
                maxLines: 1,
              ),
            ),
          ],
        ),
      );
    });
  }
}
