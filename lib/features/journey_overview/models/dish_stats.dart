import 'package:dishes_api/dishes_api.dart';

class DishStats {
  final int totalDishes;
  final int uniqueCuisines;
  final double averageRating;
  final Map<CuisineContinent, int> dishesByContinent;
  final Map<DishCategory, int> dishesByCategory;
  final List<MapEntry<DateTime, int>> dishesByMonth;
  final Map<int, int> ratingBuckets; // bucket index (0–4) → count
  final List<Dish> topDishes;

  const DishStats({
    required this.totalDishes,
    required this.uniqueCuisines,
    required this.averageRating,
    required this.dishesByContinent,
    required this.dishesByCategory,
    required this.dishesByMonth,
    required this.ratingBuckets,
    required this.topDishes,
  });

  static const empty = DishStats(
    totalDishes: 0,
    uniqueCuisines: 0,
    averageRating: 0,
    dishesByContinent: {},
    dishesByCategory: {},
    dishesByMonth: [],
    ratingBuckets: {0: 0, 1: 0, 2: 0, 3: 0, 4: 0},
    topDishes: [],
  );

  // Rating stored as 0.0–1.0, displayed as 0–10.
  // Buckets: [0–2), [2–4), [4–6), [6–8), [8–10]
  static int _ratingBucket(double rating) => ((rating * 10) ~/ 2).clamp(0, 4);

  factory DishStats.fromDishes(List<Dish> dishes) {
    if (dishes.isEmpty) return empty;

    final uniqueCuisines =
        dishes.map((d) => d.cuisine).whereType<DishCuisine>().toSet().length;

    final averageRating =
        dishes.fold(0.0, (sum, d) => sum + d.rating) / dishes.length;

    final dishesByContinent = <CuisineContinent, int>{};
    for (final dish in dishes) {
      if (dish.cuisine != null) {
        final c = dish.cuisine!.continent;
        dishesByContinent[c] = (dishesByContinent[c] ?? 0) + 1;
      }
    }

    final dishesByCategory = <DishCategory, int>{};
    for (final dish in dishes) {
      if (dish.category != null) {
        final cat = dish.category!;
        dishesByCategory[cat] = (dishesByCategory[cat] ?? 0) + 1;
      }
    }

    // Last 12 months (year-month as 'YYYY-MM' string key → count, then converted to list)
    final now = DateTime.now();
    final monthKeys = <String, (DateTime, int)>{};
    for (var i = 11; i >= 0; i--) {
      final m = DateTime(now.year, now.month - i, 1);
      final key = '${m.year}-${m.month.toString().padLeft(2, '0')}';
      monthKeys[key] = (m, 0);
    }
    for (final dish in dishes) {
      if (dish.date != null) {
        final key =
            '${dish.date!.year}-${dish.date!.month.toString().padLeft(2, '0')}';
        if (monthKeys.containsKey(key)) {
          final entry = monthKeys[key]!;
          monthKeys[key] = (entry.$1, entry.$2 + 1);
        }
      }
    }
    final dishesByMonth = monthKeys.values
        .map((e) => MapEntry(e.$1, e.$2))
        .toList();

    final ratingBuckets = <int, int>{0: 0, 1: 0, 2: 0, 3: 0, 4: 0};
    for (final dish in dishes) {
      final bucket = _ratingBucket(dish.rating);
      ratingBuckets[bucket] = ratingBuckets[bucket]! + 1;
    }

    final topDishes = [...dishes]
      ..sort((a, b) => b.rating.compareTo(a.rating));

    return DishStats(
      totalDishes: dishes.length,
      uniqueCuisines: uniqueCuisines,
      averageRating: averageRating,
      dishesByContinent: dishesByContinent,
      dishesByCategory: dishesByCategory,
      dishesByMonth: dishesByMonth,
      ratingBuckets: ratingBuckets,
      topDishes: topDishes.toList(),
    );
  }
}
