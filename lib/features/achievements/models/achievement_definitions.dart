import 'package:dishes_api/dishes_api.dart';

import 'achievement.dart';

const _bronzeI = 'assets/badges/bronze_I.png';
const _bronzeII = 'assets/badges/bronze_II.png';
const _bronzeIII = 'assets/badges/bronze_III.png';
const _silverI = 'assets/badges/silver_I.png';
const _silverII = 'assets/badges/silver_II.png';
const _silverIII = 'assets/badges/silver_III.png';
const _goldI = 'assets/badges/gold_I.png';
const _goldII = 'assets/badges/gold_II.png';
const _goldIII = 'assets/badges/gold_III.png';
const _master = 'assets/badges/master.png';

Achievement _make({
  required String id,
  required String name,
  required String description,
  required String badge,
  required int current,
  required int target,
}) {
  final clamped = current.clamp(0, target);
  return Achievement(
    id: id,
    name: name,
    description: description,
    badgeAsset: badge,
    isUnlocked: current >= target,
    progress: clamped / target,
    progressLabel: '$clamped / $target',
  );
}

List<Achievement> evaluateAchievements(List<Dish> dishes) {
  final totalDishes = dishes.length;
  final uniqueCuisines = dishes.map((d) => d.cuisine).whereType<DishCuisine>().toSet();
  final perfectRatings = dishes.where((d) => d.rating >= 1.0).length;
  final lowRatings = dishes.where((d) => d.rating < 0.25).length;

  final desserts = dishes.where((d) => d.category == DishCategory.dessert).length;
  final snacks = dishes.where((d) => d.category == DishCategory.snack).length;
  final drinks = dishes.where((d) => d.category == DishCategory.drink).length;

  final europeanCuisines = uniqueCuisines
      .where((c) => c.continent == CuisineContinent.europe)
      .length;
  final asianCuisines = uniqueCuisines.where((c) => c.continent == CuisineContinent.asia).length;

  final continentsCovered = uniqueCuisines.map((c) => c.continent).toSet().length;

  return [
    // --- Quantity milestones ---
    _make(
      id: 'first_bite',
      name: 'First Bite',
      description: 'Log your first dish',
      badge: _bronzeI,
      current: totalDishes,
      target: 1,
    ),
    _make(
      id: 'food_diary',
      name: 'Food Diary',
      description: 'Log 10 dishes',
      badge: _bronzeIII,
      current: totalDishes,
      target: 10,
    ),
    _make(
      id: 'adventurous_eater',
      name: 'Adventurous Eater',
      description: 'Log 50 dishes',
      badge: _goldII,
      current: totalDishes,
      target: 50,
    ),
    _make(
      id: 'around_the_plate',
      name: 'Around the Plate',
      description: 'Log 100 dishes',
      badge: _master,
      current: totalDishes,
      target: 100,
    ),

    // --- Exploration ---
    _make(
      id: 'neighborhood_flavors',
      name: 'Neighborhood Flavors',
      description: 'Try 3 different cuisines',
      badge: _bronzeII,
      current: uniqueCuisines.length,
      target: 3,
    ),
    _make(
      id: 'globetrotter',
      name: 'Globetrotter',
      description: 'Try 10 different cuisines',
      badge: _silverIII,
      current: uniqueCuisines.length,
      target: 10,
    ),
    _make(
      id: 'united_nations',
      name: 'United Nations',
      description: 'Try cuisines from all 5 continents',
      badge: _goldI,
      current: continentsCovered,
      target: 5,
    ),
    _make(
      id: 'european_tour',
      name: 'European Tour',
      description: 'Try 5 European cuisines',
      badge: _silverI,
      current: europeanCuisines,
      target: 5,
    ),
    _make(
      id: 'asian_explorer',
      name: 'Asian Explorer',
      description: 'Try 5 Asian cuisines',
      badge: _silverI,
      current: asianCuisines,
      target: 5,
    ),
    _make(
      id: 'full_house',
      name: 'Full House',
      description: 'Try all 38 cuisines',
      badge: _goldIII,
      current: uniqueCuisines.length,
      target: 38,
    ),

    // --- Rating-based ---
    _make(
      id: 'love_at_first_bite',
      name: 'Love at First Bite',
      description: 'Give any dish a perfect 10 rating',
      badge: _bronzeII,
      current: perfectRatings,
      target: 1,
    ),
    _make(
      id: 'five_star_chef',
      name: 'Five-Star Chef',
      description: 'Rate 5 dishes perfectly',
      badge: _silverII,
      current: perfectRatings,
      target: 5,
    ),
    _make(
      id: 'tough_critic',
      name: 'Tough Critic',
      description: 'Rate 10 dishes below 2.5',
      badge: _silverIII,
      current: lowRatings,
      target: 10,
    ),

    // --- Category specialists ---
    _make(
      id: 'sweet_tooth',
      name: 'Sweet Tooth',
      description: 'Log 10 desserts',
      badge: _bronzeIII,
      current: desserts,
      target: 10,
    ),
    _make(
      id: 'snack_attack',
      name: 'Snack Attack',
      description: 'Log 10 snacks',
      badge: _bronzeIII,
      current: snacks,
      target: 10,
    ),
    _make(
      id: 'drinks_on_me',
      name: 'Drinks on Me',
      description: 'Log 10 drinks',
      badge: _bronzeIII,
      current: drinks,
      target: 10,
    ),
  ];
}
