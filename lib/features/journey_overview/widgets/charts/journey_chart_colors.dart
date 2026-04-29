import 'package:flutter/material.dart';

const _blue = Color(0xFF4E8EF7);
const _purple = Color(0xFFAB7FF7);
const _green = Color(0xFF42B883);
const _red = Color(0xFFE85D4A);
const _amber = Color(0xFFFFB84D);
const _orange = Color(0xFFFF9900);
const _yellow = Color(0xFFFFD166);
const _mint = Color(0xFF6EC6A0);
const _gray = Color(0xFF9CA3AF);

abstract final class JourneyChartColors {
  /// Blue-to-purple gradient used on the activity line chart.
  static const gradient = [_blue, _purple];

  /// Per-category fill colors (order matches [DishCategory.values]):
  /// appetizer, dessert, drink, meal, snack.
  static const category = [_blue, _amber, _purple, _green, _red];

  /// Per-bucket colors for the rating distribution chart (0–2 → 8–10).
  static const ratingBuckets = [_red, _orange, _yellow, _mint, _green];

  /// Per-continent colors (order matches [CuisineContinent.values]):
  /// Europe, Asia, Americas, Mid East & Africa, Oceania.
  static const continent = [_blue, _red, _green, _amber, _purple];

  /// Fallback color for uncategorised / "other" entries.
  static const other = _gray;
}
