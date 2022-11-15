import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class DayView extends StatelessWidget {
  const DayView({
    required this.date,
    this.decoration,
    super.key,
  });

  final DateTime date;
  final Decoration? decoration;

  @override
  Widget build(BuildContext context) {
    final style = TextStyle(fontSize: 20).copyWith(fontSize: 20);

    return LayoutBuilder(builder: (context, constraints) {
      return Container(
        alignment: Alignment.center,
        decoration: decoration,
        padding: EdgeInsets.all(1),
        child: SizedBox(
          height: constraints.maxHeight / 1.2,
          child: AutoSizeText(
            date.day.toString(),
            style: style,
            textAlign: TextAlign.center,
            minFontSize: 4,
            maxLines: 1,
            // overflow: TextOverflow.ellipsis,
          ),
        ),
      );
    });
  }
}
