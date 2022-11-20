import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:scrolling_years_calendar/utils/interfaces.dart';

class DayView extends AbstractDayWidget {
  const DayView({
    required this.date,
    required super.dayDecorationBuilder,
    required super.dayStyleBuilder,
    super.key,
  });

  final DateTime date;

  @override
  Widget build(BuildContext context) {
    final style = dayStyleBuilder(context, date).copyWith(fontSize: 20);

    return LayoutBuilder(builder: (context, constraints) {
      return Stack(
        alignment: Alignment.center,
        children: [
          Positioned.fill(
            child: dayDecorationBuilder(context, date) ?? const SizedBox(),
          ),
          Container(
            height: constraints.maxHeight / 1.15,
            margin: const EdgeInsets.all(2.5),
            alignment: Alignment.center,
            child: AutoSizeText(
              date.day.toString(),
              style: style,
              textAlign: TextAlign.center,
              minFontSize: 4,
              maxLines: 1,
            ),
          ),
        ],
      );
    });
  }
}
