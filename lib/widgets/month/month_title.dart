import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:scrolling_years_calendar/utils/constants.dart';

class MonthTitle extends StatelessWidget {
  const MonthTitle({
    required this.month,
    required this.date,
    required this.monthTitleStyleBuilder,
    required this.monthDecorationBuilder,
    super.key,
  });

  final String month;
  final DateTime date;
  final TextStyleBuilder monthTitleStyleBuilder;
  final DecorationWidgetBuilder monthDecorationBuilder;

  @override
  Widget build(BuildContext context) {
    final style = monthTitleStyleBuilder(context, date).copyWith(fontSize: 40);

    return Stack(
      children: [
        monthDecorationBuilder(context, date) ?? const SizedBox(),
        AutoSizeText(
          month,
          maxLines: 1,
          style: style,
          minFontSize: 8,
          stepGranularity: 2,
          group: AutoSizeGroup(),
        ),
      ],
    );
  }
}
