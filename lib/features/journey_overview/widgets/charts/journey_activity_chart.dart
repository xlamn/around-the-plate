import 'package:app_theme/app_theme.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../models/dish_stats.dart';
import 'journey_chart_colors.dart';

class JourneyActivityChart extends StatelessWidget {
  final DishStats stats;

  const JourneyActivityChart({super.key, required this.stats});

  @override
  Widget build(BuildContext context) {
    final months = stats.dishesByMonth;
    return months.isEmpty ? _empty(context) : _buildChart(context, months);
  }

  Widget _buildChart(
    BuildContext context,
    List<MapEntry<DateTime, int>> months,
  ) {
    final maxY = months.map((e) => e.value).fold(0, (a, b) => a > b ? a : b).toDouble();
    final spots = months
        .asMap()
        .entries
        .map((e) => FlSpot(e.key.toDouble(), e.value.value.toDouble()))
        .toList();

    return Container(
      decoration: BoxDecoration(
        color: context.theme.colors.secondary,
        borderRadius: .circular(AppSizes.radiusS),
      ),
      padding: const .symmetric(
        horizontal: AppSizes.spacing12,
        vertical: AppSizes.spacing8,
      ),
      child: SizedBox(
        height: 148,
        child: LineChart(
          LineChartData(
            minX: 0,
            maxX: (months.length - 1).toDouble(),
            minY: 0,
            maxY: maxY == 0 ? 5 : maxY * 1.4,
            gridData: const FlGridData(show: false),
            borderData: FlBorderData(show: false),
            lineTouchData: LineTouchData(
              touchTooltipData: LineTouchTooltipData(
                getTooltipColor: (_) => context.theme.colors.card,
                getTooltipItems: (touchedSpots) => touchedSpots.map((spot) {
                  final i = spot.x.toInt();
                  if (i < 0 || i >= months.length) return null;
                  final label = DateFormat('MMM yyyy').format(months.elementAt(i).key);
                  return LineTooltipItem(
                    '$label\n${spot.y.toInt()} dish(es)',
                    context.theme.typography.xs.copyWith(
                      color: context.theme.colors.foreground,
                    ),
                  );
                }).toList(),
              ),
            ),
            titlesData: FlTitlesData(
              leftTitles: const AxisTitles(),
              rightTitles: const AxisTitles(),
              topTitles: const AxisTitles(),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  interval: 1,
                  reservedSize: 20,
                  getTitlesWidget: (value, meta) {
                    final i = value.toInt();
                    if (i < 0 || i >= months.length || value != i.toDouble()) {
                      return const SizedBox.shrink();
                    }
                    final isLast = i == months.length - 1;
                    if (i % 3 != 0 && !isLast) {
                      return const SizedBox.shrink();
                    }
                    return Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        DateFormat('MMM').format(months[i].key),
                        style: context.theme.typography.xs.copyWith(
                          fontSize: 10,
                          color: isLast
                              ? JourneyChartColors.gradient.elementAt(1)
                              : context.theme.colors.mutedForeground,
                          fontWeight: isLast ? .w600 : .normal,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            lineBarsData: [
              LineChartBarData(
                spots: spots,
                isCurved: true,
                curveSmoothness: 0.35,
                preventCurveOverShooting: true,
                gradient: const LinearGradient(colors: JourneyChartColors.gradient),
                barWidth: 3,
                isStrokeCapRound: true,
                dotData: const FlDotData(show: false),
                belowBarData: BarAreaData(
                  show: true,
                  gradient: LinearGradient(
                    colors: JourneyChartColors.gradient
                        .map((c) => c.withValues(alpha: 0.25))
                        .toList(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _empty(BuildContext context) => Padding(
    padding: const .symmetric(vertical: AppSizes.spacing24),
    child: Center(
      child: Text(
        'No activity data yet',
        style: TextStyle(color: context.theme.colors.mutedForeground),
      ),
    ),
  );
}
