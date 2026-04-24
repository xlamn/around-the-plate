import 'package:flutter/material.dart';

import '../../../achievements/achievements.dart';
import '../journey_achievements_grid.dart';
import '../journey_section.dart';

class JourneyAchievementsSection extends StatelessWidget {
  final List<Achievement> achievements;
  final VoidCallback? onMoreTap;

  const JourneyAchievementsSection({
    super.key,
    required this.achievements,
    this.onMoreTap,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = JourneyAchievementsGrid.columnCount(constraints.maxWidth);
        final locked = achievements.where((a) => !a.isUnlocked).toList();
        final displayed = locked.take(columns).toList();

        if (displayed.isEmpty) return const SizedBox.shrink();

        return JourneySection(
          title: 'Achievements',
          onTap: onMoreTap,
          child: JourneyAchievementsGrid(achievements: displayed),
        );
      },
    );
  }
}
