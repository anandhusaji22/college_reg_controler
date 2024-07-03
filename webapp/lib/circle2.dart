import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

class CircleIndicator2 extends StatelessWidget {
  final double radius;
  final double percent;
  final Color progressColor;
  final String centerText;

  const CircleIndicator2({
    Key? key,
    required this.radius,
    required this.percent,
    required this.progressColor,
    required this.centerText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CircularPercentIndicator(
      radius: radius,
      lineWidth: 40.0,
      percent: percent,
      center: Text(
        centerText,
        style: const TextStyle(fontSize: 20.0,fontWeight: FontWeight.bold),
      ),
      progressColor: progressColor,
    );
  }
}
