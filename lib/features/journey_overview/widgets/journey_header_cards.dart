import 'package:app_theme/app_theme.dart';
import 'package:flutter/material.dart';

import '../models/dish_stats.dart';

class JourneyHeaderCards extends StatelessWidget {
  final DishStats stats;
  final int tripCount;

  const JourneyHeaderCards({
    super.key,
    required this.stats,
    required this.tripCount,
  });

  @override
  Widget build(BuildContext context) {
    final rating = (stats.averageRating * 10).toStringAsFixed(1);
    return Padding(
      padding: const .symmetric(horizontal: AppSizes.spacing16),
      child: Row(
        spacing: 8.0,
        children: [
          _StatCard(
            label: 'Dishes',
            value: '${stats.totalDishes}',
          ),
          _StatCard(
            label: 'Trips',
            value: '$tripCount',
          ),
          _StatCard(
            label: 'Avg Rating',
            value: stats.totalDishes == 0 ? '—' : rating,
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;

  const _StatCard({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: AppSizes.spacing16,
          horizontal: AppSizes.spacing8,
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: .topCenter,
            end: .bottomCenter,
            colors: [
              context.theme.colors.card,
              context.theme.colors.muted,
            ],
          ),
          borderRadius: .circular(AppSizes.radiusM),
          border: .all(
            color: context.theme.colors.border,
            width: 0.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          children: [
            Text(
              value,
              style: context.theme.typography.xl.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: AppSizes.spacing4),
            Text(
              label,
              style: context.theme.typography.xs.copyWith(
                color: context.theme.colors.mutedForeground,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
