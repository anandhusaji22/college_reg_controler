import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

class CircleIndicator extends StatelessWidget {
  final double radius;
  final double percent;
  final Color progressColor;
  final String centerText;

  const CircleIndicator({
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
      lineWidth: 50.0,
      percent: percent,
      center: Text(
        centerText,
        style: const TextStyle(fontSize: 30.0,fontWeight: FontWeight.bold),
      ),
      progressColor: progressColor,
    );
  }
}
