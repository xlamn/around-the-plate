import 'package:app_theme/app_theme.dart';
import 'package:flutter/material.dart';

import '../models/achievement.dart';

class AchievementTile extends StatelessWidget {
  final Achievement achievement;

  const AchievementTile({super.key, required this.achievement});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const .all(AppSizes.spacing12),
      decoration: BoxDecoration(
        color: context.theme.colors.muted,
        borderRadius: .circular(AppSizes.radiusM),
        border: .all(
          color: context.theme.colors.border,
          width: 0.5,
        ),
      ),
      child: Column(
        spacing: AppSizes.spacing8,
        crossAxisAlignment: .center,
        children: [
          const Spacer(),
          Opacity(
            opacity: achievement.isUnlocked ? 1.0 : 0.4,
            child: ColorFiltered(
              colorFilter: achievement.isUnlocked
                  ? const ColorFilter.mode(Colors.transparent, BlendMode.dst)
                  : const ColorFilter.matrix([
                      0.2126,
                      0.7152,
                      0.0722,
                      0,
                      0,
                      0.2126,
                      0.7152,
                      0.0722,
                      0,
                      0,
                      0.2126,
                      0.7152,
                      0.0722,
                      0,
                      0,
                      0,
                      0,
                      0,
                      1,
                      0,
                    ]),
              child: Image.asset(
                achievement.badgeAsset,
                width: 72,
                height: 72,
              ),
            ),
          ),
          Column(
            spacing: AppSizes.spacing4,
            children: [
              Text(
                achievement.name,
                style: context.theme.typography.xs.copyWith(
                  fontWeight: .w600,
                ),
                textAlign: .center,
                maxLines: 2,
                overflow: .ellipsis,
              ),
              Text(
                achievement.description,
                style: context.theme.typography.xs.copyWith(
                  fontSize: 11,
                  color: context.theme.colors.mutedForeground,
                ),
                textAlign: .center,
                maxLines: 2,
                overflow: .ellipsis,
              ),
            ],
          ),

          const Spacer(),
          if (!achievement.isUnlocked)
            Visibility(
              visible: !achievement.isUnlocked,
              maintainSize: true,
              maintainState: true,
              maintainAnimation: true,
              child: Column(
                spacing: AppSizes.spacing4,
                children: [
                  Padding(
                    padding: const .symmetric(horizontal: 8.0),
                    child: ClipRRect(
                      borderRadius: .circular(4),
                      child: LinearProgressIndicator(
                        value: achievement.progress,
                        minHeight: 4,
                        backgroundColor: context.theme.colors.border,
                        valueColor: AlwaysStoppedAnimation(
                          context.theme.colors.primary,
                        ),
                      ),
                    ),
                  ),
                  Text(
                    achievement.progressLabel,
                    style: context.theme.typography.xs.copyWith(
                      fontSize: 10,
                      color: context.theme.colors.mutedForeground,
                    ),
                  ),
                ],
              ),
            ),
          const Spacer(),
        ],
      ),
    );
  }
}
