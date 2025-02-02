import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/percent_indicator.dart';

class CircularProgressWidget extends StatelessWidget {
  final int score;
  const CircularProgressWidget({required this.score});

  @override
  Widget build(BuildContext context) {
    return CircularPercentIndicator(
      radius: 75, // Adjust the size as needed
      lineWidth: 10, // Thickness of the progress arc
      percent: 0.75, // Fixed 75% progress
      backgroundColor: Colors.teal[100]!,
      progressColor: Colors.teal[300]!,
      circularStrokeCap: CircularStrokeCap.round,
      center: Text(
        '$score',
        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFFF6AF58)),
      ),
      arcType: ArcType.FULL,
      arcBackgroundColor: Colors.transparent,
    );
  }
}
