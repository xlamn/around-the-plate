import 'package:app_theme/app_theme.dart';
import 'package:flutter/material.dart';

import '../../../achievements/achievements.dart';
import '../journey_achievements_grid.dart';

class JourneyAchievementsDetailPage extends StatelessWidget {
  final List<Achievement> achievements;

  const JourneyAchievementsDetailPage({super.key, required this.achievements});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const SliverAppBar(),
          SliverToBoxAdapter(
            child: SafeArea(
              top: false,
              child: Padding(
                padding: const .all(AppSizes.spacing16),
                child: JourneyAchievementsGrid(
                  achievements: achievements,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
