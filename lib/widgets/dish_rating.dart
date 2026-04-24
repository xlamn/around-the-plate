import 'package:flutter/material.dart';

import '../extensions/extensions.dart';

class DishRating extends StatelessWidget {
  final double rating;
  final double? fontSize;

  const DishRating({super.key, required this.rating, this.fontSize});

  @override
  Widget build(BuildContext context) {
    final value = rating * 10;

    final color = Color.lerp(
      Colors.red,
      Colors.green,
      value / 10,
    )!;

    final adjustedFontSize = (fontSize ?? 20) + (value - 1) * 1.1;

    return Text(
      '${value.roundDecimals(1)}',
      style: TextStyle(
        fontSize: adjustedFontSize,
        fontWeight: .bold,
        color: color,
      ),
    );
  }
}
