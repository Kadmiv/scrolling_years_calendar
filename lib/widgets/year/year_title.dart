import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:scrolling_years_calendar/utils/constants.dart';

class YearTitle extends StatelessWidget {
  const YearTitle({
    required this.date,
    required this.yearTitleStyleBuilder,
    required this.yearDecorationBuilder,
    super.key,
  });

  final DateTime date;
  final TextStyleBuilder yearTitleStyleBuilder;
  final DecorationWidgetBuilder yearDecorationBuilder;

  @override
  Widget build(BuildContext context) {
    final style = yearTitleStyleBuilder(context, date).copyWith(fontSize: 60);

    return Stack(
      alignment: Alignment.centerLeft,
      children: [
        yearDecorationBuilder(context, date) ?? const SizedBox(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 1),
          child: AutoSizeText(
            date.year.toString(),
            style: style,
            // textAlign: TextAlign.center,
            minFontSize: 10,
            stepGranularity: 2,
            maxLines: 1,
            group: AutoSizeGroup(),
          ),
        ),
      ],
    );
  }
}
