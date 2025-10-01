import 'package:flutter/material.dart';

class ScoreBoard extends StatelessWidget {
  final String elapsedSec;
  final int lastScore;
  final int bestScore;
  final int totalScore;

  const ScoreBoard({
    super.key,
    required this.elapsedSec,
    required this.lastScore,
    required this.bestScore,
    required this.totalScore,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('Elapsed: ${elapsedSec}s'),
        Text('Last: $lastScore'),
        Text('Best: $bestScore'),
        Text('Total: $totalScore'),
      ],
    );
  }
}
