import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class DayNumber extends StatelessWidget {
  const DayNumber({
    required this.day,
    this.decoration,
    super.key,
  });

  final String day;
  final Decoration? decoration;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      decoration: decoration,
      padding: EdgeInsets.all(1),
      child: AutoSizeText(
        day,
        style: TextStyle(fontSize: 20),
        textAlign: TextAlign.center,
        minFontSize: 4,
        maxLines: 1,
        // overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
