import 'package:flutter/material.dart';

import '../../models/dish_stats.dart';
import '../charts/journey_region_chart.dart';
import '../journey_section.dart';

class JourneyStatsSection extends StatelessWidget {
  final DishStats stats;
  final VoidCallback? onTap;

  const JourneyStatsSection({super.key, required this.stats, this.onTap});

  @override
  Widget build(BuildContext context) {
    return JourneySection(
      title: 'Statistics',
      onTap: onTap,
      child: JourneyRegionChart(stats: stats),
    );
  }
}
