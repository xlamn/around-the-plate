import 'package:around_the_plate/features/journey_overview/widgets/journey_dish_row.dart';
import 'package:flutter/material.dart';

import '../../models/dish_stats.dart';
import '../journey_section.dart';

class JourneyTopDishesSection extends StatelessWidget {
  final DishStats stats;
  final VoidCallback? onTap;

  const JourneyTopDishesSection({super.key, required this.stats, this.onTap});

  @override
  Widget build(BuildContext context) {
    if (stats.topDishes.isEmpty) return const SizedBox.shrink();

    return JourneySection(
      title: 'Top Dishes',
      onTap: onTap,
      child: Column(
        children: stats.topDishes.take(3).map((dish) => JourneyDishRow(dish: dish)).toList(),
      ),
    );
  }
}
