extension DoubleRoundingExtension on double {
  double roundDecimals(int decimals) => double.parse(toStringAsFixed(decimals));
}
