import 'package:app_theme/app_theme.dart';
import 'package:around_the_plate/features/journey_overview/widgets/journey_dish_row.dart';
import 'package:flutter/material.dart';

import '../../models/dish_stats.dart';

class JourneyTopDishesDetailPage extends StatelessWidget {
  final DishStats stats;

  const JourneyTopDishesDetailPage({super.key, required this.stats});

  @override
  Widget build(BuildContext context) {
    final top10 = stats.topDishes.take(10).toList();
    final flop10 = stats.topDishes.reversed.take(10).toList();

    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        padding: const .symmetric(
          horizontal: AppSizes.spacing16,
          vertical: AppSizes.spacing12,
        ),
        child: Column(
          crossAxisAlignment: .start,
          spacing: AppSizes.spacing24,
          children: [
            Column(
              crossAxisAlignment: .start,
              spacing: AppSizes.spacing16,
              children: [
                Text(
                  'Top 10',
                  style: context.theme.typography.md.copyWith(
                    fontWeight: .w600,
                  ),
                ),
                Column(
                  children: top10.map((dish) => JourneyDishRow(dish: dish)).toList(),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: .start,
              spacing: AppSizes.spacing16,
              children: [
                Text(
                  'Flop 10',
                  style: context.theme.typography.md.copyWith(
                    fontWeight: .w600,
                  ),
                ),
                Column(
                  children: flop10.map((dish) => JourneyDishRow(dish: dish)).toList(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
