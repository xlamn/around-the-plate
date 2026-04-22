import 'package:flutter/material.dart';

import '../../../extensions/extensions.dart';

class DishDetailsRating extends StatelessWidget {
  final double rating;

  const DishDetailsRating({super.key, required this.rating});

  @override
  Widget build(BuildContext context) {
    final value = rating * 10;
    final color = Color.lerp(Colors.red, Colors.green, value / 10)!;

    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color.withValues(alpha: 0.12),
        border: Border.all(color: color.withValues(alpha: 0.5), width: 2),
      ),
      child: Center(
        child: Text(
          value.roundDecimals(1).toString(),
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.bold,
            fontSize: 20,
            height: 1,
          ),
        ),
      ),
    );
  }
}
