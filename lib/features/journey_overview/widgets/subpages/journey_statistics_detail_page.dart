import 'package:app_theme/app_theme.dart';
import 'package:flutter/material.dart';

import '../../models/dish_stats.dart';
import '../charts/journey_activity_chart.dart';
import '../charts/journey_category_chart.dart';
import '../charts/journey_rating_chart.dart';
import '../charts/journey_region_chart.dart';
import '../journey_section.dart';

class JourneyStatisticsDetailPage extends StatelessWidget {
  final DishStats stats;

  const JourneyStatisticsDetailPage({super.key, required this.stats});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            spacing: AppSizes.spacing12,
            children: [
              JourneySection(
                title: 'Activity',
                child: JourneyActivityChart(stats: stats),
              ),
              JourneySection(
                title: 'Dishes by Category',
                child: JourneyCategoryChart(stats: stats),
              ),
              JourneySection(
                title: 'Dishes by Region',
                child: JourneyRegionChart(stats: stats),
              ),
              JourneySection(
                title: 'Rating Distribution',
                child: JourneyRatingChart(stats: stats),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
