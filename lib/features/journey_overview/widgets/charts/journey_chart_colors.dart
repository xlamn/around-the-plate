import 'package:flutter/material.dart';

const _blue = Color(0xFF7AB8DF);
const _pink = Color(0xFFDB3374);
const _violet = Color(0xFF9B72E8);
const _teal = Color(0xFF2AC4B0);
const _lime = Color(0xFF85D65A);
const _amber = Color(0xFFF5B942);
const _sky = Color(0xFF4DA8E8);
const _slate = Color(0xFF5A6888);

abstract final class JourneyChartColors {
  /// Blue-to-pink gradient for the activity line chart.
  static const gradient = [_blue, _pink];

  /// Per-category fill colors (order matches [DishCategory.values]):
  /// appetizer, dessert, drink, meal, snack.
  static const category = [_blue, _pink, _violet, _teal, _lime];

  /// Per-bucket colors for the rating distribution chart (0–2 → 8–10).
  static const ratingBuckets = [_pink, _amber, _amber, _teal, _blue];

  /// Per-continent colors (order matches [CuisineContinent.values]):
  /// Europe, Asia, Americas, Mid East & Africa, Oceania.
  static const continent = [_sky, _pink, _lime, _amber, _violet];

  /// Fallback color for uncategorised / "other" entries.
  static const other = _slate;
}
