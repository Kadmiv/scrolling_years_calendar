import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class MonthTitle extends StatelessWidget {
  const MonthTitle({
    required this.month,
    this.style = const TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w600,
    ),
    super.key,
  });

  final String month;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    final style = TextStyle(fontSize: 20).copyWith(fontSize: 40);

    return Container(
      child: AutoSizeText(
        month,
        maxLines: 1,
        style: style,
        minFontSize: 8,
        stepGranularity: 2,
        group: AutoSizeGroup(),
      ),
      // Text(
      //   month,
      //   style: style,
      //   maxLines: 1,
      //   overflow: TextOverflow.fade,
      //   softWrap: false,
      // ),
    );
  }
}
