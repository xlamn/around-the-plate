import 'package:app_theme/app_theme.dart';
import 'package:dishes_api/dishes_api.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../models/dish_stats.dart';
import 'journey_chart_colors.dart';

const _shortLabels = ['EU', 'Asia', 'Am.', 'ME&Af', 'Oc.'];

class JourneyRegionChart extends StatelessWidget {
  final DishStats stats;

  const JourneyRegionChart({super.key, required this.stats});

  @override
  Widget build(BuildContext context) {
    if (stats.totalDishes == 0) return _empty(context);

    final categorizedCount = stats.dishesByContinent.values.fold(0, (a, b) => a + b);
    final otherCount = stats.totalDishes - categorizedCount;

    final entries = <_BarEntry>[
      ...CuisineContinent.values.asMap().entries.map(
        (e) => _BarEntry(
          _shortLabels[e.key],
          e.value.label,
          JourneyChartColors.continent[e.key],
          stats.dishesByContinent[e.value] ?? 0,
        ),
      ),
      if (otherCount > 0) _BarEntry('None', 'No category', JourneyChartColors.other, otherCount),
    ];

    final grandTotal = categorizedCount + otherCount;
    final maxValue = entries.map((e) => e.count).fold(0, (a, b) => a > b ? a : b).toDouble();

    return Container(
      decoration: BoxDecoration(
        color: context.theme.colors.secondary,
        borderRadius: .circular(AppSizes.radiusS),
      ),
      padding: const .symmetric(
        horizontal: AppSizes.spacing4,
        vertical: AppSizes.spacing8,
      ),
      child: SizedBox(
        height: 180,
        child: BarChart(
          BarChartData(
            maxY: maxValue == 0 ? 5 : maxValue * 1.5,
            gridData: const FlGridData(show: false),
            borderData: FlBorderData(show: false),
            barTouchData: BarTouchData(
              touchTooltipData: BarTouchTooltipData(
                getTooltipColor: (_) => context.theme.colors.card,
                getTooltipItem: (group, groupIndex, rod, rodIndex) {
                  if (groupIndex >= entries.length) return null;
                  final entry = entries[groupIndex];
                  return BarTooltipItem(
                    '${entry.fullLabel}\n${rod.toY.toInt()}',
                    context.theme.typography.xs.copyWith(
                      color: context.theme.colors.foreground,
                    ),
                  );
                },
              ),
            ),
            titlesData: FlTitlesData(
              leftTitles: const AxisTitles(),
              rightTitles: const AxisTitles(),
              topTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 20,
                  getTitlesWidget: (value, meta) {
                    final i = value.toInt();
                    if (i < 0 || i >= entries.length) {
                      return const SizedBox.shrink();
                    }
                    final entry = entries[i];
                    if (grandTotal == 0 || entry.count == 0) {
                      return const SizedBox.shrink();
                    }
                    final pct = (entry.count / grandTotal * 100).round();
                    return Text(
                      '$pct%',
                      style: context.theme.typography.xs.copyWith(
                        fontSize: 10,
                        fontWeight: .w600,
                        color: entry.color,
                      ),
                    );
                  },
                ),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 24,
                  getTitlesWidget: (value, meta) {
                    final i = value.toInt();
                    if (i < 0 || i >= entries.length) {
                      return const SizedBox.shrink();
                    }
                    return Padding(
                      padding: const .symmetric(vertical: AppSizes.spacing4),
                      child: Text(
                        entries[i].shortLabel,
                        style: context.theme.typography.xs.copyWith(
                          fontSize: 10,
                          color: context.theme.colors.mutedForeground,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            barGroups: entries.asMap().entries.map((entry) {
              final i = entry.key;
              final bar = entry.value;
              return BarChartGroupData(
                x: i,
                barRods: [
                  BarChartRodData(
                    toY: bar.count.toDouble(),
                    gradient: LinearGradient(
                      colors: [
                        bar.color.withValues(alpha: 0.4),
                        bar.color,
                      ],
                      begin: .bottomCenter,
                      end: .topCenter,
                    ),
                    width: 28,
                    borderRadius: const .vertical(
                      top: .circular(8),
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget _empty(BuildContext context) => Padding(
    padding: const .symmetric(vertical: AppSizes.spacing24),
    child: Center(
      child: Text(
        'No cuisine data yet',
        style: TextStyle(color: context.theme.colors.mutedForeground),
      ),
    ),
  );
}

class _BarEntry {
  final String shortLabel;
  final String fullLabel;
  final Color color;
  final int count;
  const _BarEntry(this.shortLabel, this.fullLabel, this.color, this.count);
}
