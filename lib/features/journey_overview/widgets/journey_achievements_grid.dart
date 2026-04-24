import 'package:app_theme/app_theme.dart';
import 'package:flutter/material.dart';

import '../../achievements/achievements.dart';
import 'journey_achievement_tile.dart';

class JourneyAchievementsGrid extends StatelessWidget {
  final List<Achievement> achievements;

  const JourneyAchievementsGrid({
    super.key,
    required this.achievements,
  });

  static const _spacing = AppSizes.spacing12;
  static const tabletBreakpoint = 600.0;

  static int columnCount(double availableWidth) => availableWidth >= tabletBreakpoint ? 3 : 2;

  @override
  Widget build(BuildContext context) {
    if (achievements.isEmpty) return const SizedBox.shrink();

    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = columnCount(constraints.maxWidth);
        return GridView.builder(
          shrinkWrap: true,
          padding: .zero,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            crossAxisSpacing: _spacing,
            mainAxisSpacing: _spacing,
            childAspectRatio: 0.72,
          ),
          itemCount: achievements.length,
          itemBuilder: (context, index) => JourneyAchievementTile(achievement: achievements[index]),
        );
      },
    );
  }
}
