import 'package:app_theme/app_theme.dart';
import 'package:dishes_api/dishes_api.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../models/dish_stats.dart';
import 'journey_chart_colors.dart';

class JourneyCategoryChart extends StatelessWidget {
  final DishStats stats;

  const JourneyCategoryChart({super.key, required this.stats});

  @override
  Widget build(BuildContext context) {
    final grandTotal = stats.totalDishes;
    return grandTotal == 0 ? _empty(context) : _content(context, grandTotal);
  }

  Widget _content(BuildContext context, int grandTotal) {
    final categorizedTotal = stats.dishesByCategory.values.fold(0, (a, b) => a + b);
    final uncategorizedCount = grandTotal - categorizedTotal;

    final entries = <_Entry>[
      ...DishCategory.values.asMap().entries.map(
        (e) => _Entry(
          e.value.label,
          JourneyChartColors.category[e.key],
          stats.dishesByCategory[e.value] ?? 0,
        ),
      ),
      if (uncategorizedCount > 0) _Entry('None', JourneyChartColors.other, uncategorizedCount),
    ]..sort((a, b) => b.count.compareTo(a.count));

    final sections = entries
        .where((e) => e.count > 0)
        .map(
          (e) => PieChartSectionData(
            value: e.count.toDouble(),
            gradient: LinearGradient(
              colors: [e.color.withValues(alpha: 0.6), e.color],
              begin: .topLeft,
              end: .bottomRight,
            ),
            title: '',
            radius: 44,
          ),
        )
        .toList();

    return Container(
      decoration: BoxDecoration(
        color: context.theme.colors.secondary,
        borderRadius: .circular(AppSizes.radiusS),
      ),
      padding: const .all(AppSizes.spacing16),
      child: Row(
        spacing: AppSizes.spacing24,
        crossAxisAlignment: .center,
        children: [
          SizedBox(
            height: 160,
            width: 160,
            child: Stack(
              alignment: .center,
              children: [
                PieChart(
                  PieChartData(
                    sectionsSpace: 3,
                    centerSpaceRadius: 42,
                    startDegreeOffset: -90,
                    sections: sections,
                  ),
                ),
                Column(
                  mainAxisSize: .min,
                  children: [
                    Text(
                      '$grandTotal',
                      style: context.theme.typography.xl.copyWith(
                        fontWeight: .w700,
                        height: 1,
                      ),
                    ),
                    Text(
                      'dishes',
                      style: context.theme.typography.xs.copyWith(
                        color: context.theme.colors.mutedForeground,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: .start,
              mainAxisSize: .min,
              children: entries.where((e) => e.count > 0).map((e) {
                final pct = grandTotal > 0 ? (e.count / grandTotal * 100).round() : 0;
                return Padding(
                  padding: const .symmetric(
                    vertical: AppSizes.spacing4,
                  ),
                  child: Row(
                    spacing: AppSizes.spacing8,
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: e.color,
                          shape: .circle,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          e.label,
                          style: context.theme.typography.xs,
                        ),
                      ),
                      Text(
                        '${e.count}',
                        style: context.theme.typography.xs.copyWith(
                          fontWeight: .w600,
                        ),
                      ),
                      Text(
                        '$pct%',
                        textAlign: .right,
                        style: context.theme.typography.xs.copyWith(
                          fontSize: 10,
                          color: context.theme.colors.mutedForeground,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _empty(BuildContext context) => Padding(
    padding: const .symmetric(vertical: AppSizes.spacing24),
    child: Center(
      child: Text(
        'No category data yet',
        style: TextStyle(color: context.theme.colors.mutedForeground),
      ),
    ),
  );
}

class _Entry {
  final String label;
  final Color color;
  final int count;
  const _Entry(this.label, this.color, this.count);
}
