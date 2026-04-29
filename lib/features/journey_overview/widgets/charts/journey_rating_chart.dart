import 'package:app_theme/app_theme.dart';
import 'package:flutter/material.dart';

import '../../models/dish_stats.dart';
import 'journey_chart_colors.dart';

const _bucketLabels = ['0–2', '2–4', '4–6', '6–8', '8–10'];

class JourneyRatingChart extends StatelessWidget {
  final DishStats stats;

  const JourneyRatingChart({super.key, required this.stats});

  @override
  Widget build(BuildContext context) {
    final buckets = stats.ratingBuckets;
    final total = buckets.values.fold(0, (a, b) => a + b);
    return total == 0 ? _empty(context) : _content(context, buckets, total);
  }

  Widget _content(
    BuildContext context,
    Map<int, int> buckets,
    int total,
  ) {
    final avgDisplay = (stats.averageRating * 10).toStringAsFixed(1);

    return Container(
      decoration: BoxDecoration(
        color: context.theme.colors.secondary,
        borderRadius: .circular(AppSizes.radiusS),
      ),
      padding: const .all(AppSizes.spacing16),
      child: Column(
        crossAxisAlignment: .start,
        spacing: AppSizes.spacing16,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '$avgDisplay ',
                style: context.theme.typography.xl2.copyWith(
                  fontWeight: .w700,
                  height: 1,
                ),
              ),
              Padding(
                padding: const .only(bottom: 4),
                child: Text(
                  '/ 10',
                  style: context.theme.typography.sm.copyWith(
                    color: context.theme.colors.mutedForeground,
                    height: 1,
                  ),
                ),
              ),
              const Spacer(),
              Text(
                'avg score',
                style: context.theme.typography.xs.copyWith(
                  color: context.theme.colors.mutedForeground,
                ),
              ),
            ],
          ),
          Column(
            children: List.generate(5, (i) {
              final count = buckets[i] ?? 0;
              final pct = total > 0 ? count / total : 0.0;
              return Padding(
                padding: const .symmetric(vertical: AppSizes.spacing4),
                child: Row(
                  spacing: AppSizes.spacing8,
                  children: [
                    SizedBox(
                      width: 30,
                      child: Text(
                        _bucketLabels.elementAt(i),
                        style: context.theme.typography.xs.copyWith(
                          fontSize: 10,
                          color: context.theme.colors.mutedForeground,
                        ),
                      ),
                    ),
                    Expanded(
                      child: _GradientBar(
                        value: pct,
                        color: JourneyChartColors.ratingBuckets.elementAt(i),
                        backgroundColor: context.theme.colors.border,
                      ),
                    ),
                    SizedBox(
                      width: 20,
                      child: Text(
                        '$count',
                        textAlign: .right,
                        style: context.theme.typography.xs.copyWith(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _empty(BuildContext context) => Padding(
    padding: const .symmetric(vertical: AppSizes.spacing24),
    child: Center(
      child: Text(
        'No ratings yet',
        style: TextStyle(color: context.theme.colors.mutedForeground),
      ),
    ),
  );
}

class _GradientBar extends StatelessWidget {
  final double value;
  final Color color;
  final Color backgroundColor;

  const _GradientBar({
    required this.value,
    required this.color,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final fillWidth = constraints.maxWidth * value;
        return ClipRRect(
          borderRadius: .circular(6),
          child: SizedBox(
            height: 8,
            child: Stack(
              children: [
                Container(color: backgroundColor),
                if (fillWidth > 0)
                  Container(
                    width: fillWidth,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          color.withValues(alpha: 0.6),
                          color,
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
