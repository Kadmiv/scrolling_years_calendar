import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class YearTitle extends StatelessWidget {
  const YearTitle(this.date, {super.key});

  final DateTime date;

  @override
  Widget build(BuildContext context) {
    final style = TextStyle(fontSize: 20).copyWith(fontSize: 60);

    return Container(
      child: AutoSizeText(
        date.year.toString(),
        style: style,
        // textAlign: TextAlign.center,
        minFontSize: 10,
        stepGranularity: 2,
        maxLines: 1,
        group: AutoSizeGroup(),
      ),
    );
  }
}
