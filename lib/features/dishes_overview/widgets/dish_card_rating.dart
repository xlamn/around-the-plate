import 'package:flutter/material.dart';

import '../../../extensions/extensions.dart';

class DishCardRating extends StatelessWidget {
  final double rating;

  const DishCardRating({super.key, required this.rating});

  @override
  Widget build(BuildContext context) {
    final value = rating * 10;

    final color = Color.lerp(
      Colors.red,
      Colors.green,
      value / 10,
    )!;

    final fontSize = 20 + (value - 1) * 1.1;
    final glow = value * 2;

    return Text(
      '${value.roundDecimals(2)}',
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: FontWeight.bold,
        color: color,
        shadows: [
          Shadow(
            color: color.withValues(alpha: 0.2),
            blurRadius: glow,
            offset: const Offset(0, 0),
          ),
        ],
      ),
    );
  }
}
