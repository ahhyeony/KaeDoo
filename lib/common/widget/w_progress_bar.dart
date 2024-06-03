import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

class ProgressBar extends StatelessWidget {
  final double percent;

  ProgressBar({required this.percent});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        LinearPercentIndicator(
          width: MediaQuery.of(context).size.width - 50,
          lineHeight: 14.0,
          percent: percent,
          backgroundColor: const Color(0x50D3D3D3),
          progressColor: const Color(0xff94B396),
        ),
      ],
    );
  }
}
