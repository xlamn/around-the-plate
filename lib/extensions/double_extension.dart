import 'package:flutter/material.dart';

extension DoubleRoundingExtension on double {
  double roundDecimals(int decimals) => double.parse(toStringAsFixed(decimals));
}

extension DoubleColorExtension on double {
  /// Generates a hex color string by interpolating between [startColor] and [endColor]
  /// based on the value of the double (expected to be between 0.0 and 1.0).
  String generateColorFromNumber({
    Color startColor = const Color(0xFFFFFFFF),
    Color endColor = const Color(0xFF000000),
  }) {
    final Color? interpolatedColor = Color.lerp(
      startColor,
      endColor,
      // ignore: unnecessary_this
      this.clamp(0.0, 1.0),
    );

    final Color finalColor = interpolatedColor ?? startColor;
    final String hexValue = finalColor
        .toARGB32()
        .toRadixString(16)
        .padLeft(8, '0');

    return '#${hexValue.substring(2)}';
  }
}
