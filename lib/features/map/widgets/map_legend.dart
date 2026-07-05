import 'package:app_theme/app_theme.dart';
import 'package:flutter/material.dart';

import '../constants/map_gradient.dart';

class MapLegend extends StatelessWidget {
  const MapLegend({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const .symmetric(
        horizontal: AppSizes.spacing12,
        vertical: AppSizes.spacing8,
      ),
      decoration: BoxDecoration(
        color: context.theme.colors.background,
        borderRadius: BorderRadius.circular(AppSizes.radiusM),
        border: .all(color: context.theme.colors.border),
      ),
      child: IntrinsicWidth(
        child: Column(
          mainAxisSize: .min,
          crossAxisAlignment: .stretch,
          spacing: AppSizes.spacing4,
          children: [
            Container(
              height: 8,
              decoration: BoxDecoration(
                borderRadius: .circular(AppSizes.radiusS),
                gradient: const LinearGradient(
                  colors: [
                    MapGradient.startColor,
                    MapGradient.midColor,
                    MapGradient.endColor,
                  ],
                ),
              ),
            ),
            Row(
              mainAxisSize: .min,
              spacing: AppSizes.spacing24,
              children: [
                Text('Fewer dishes', style: context.theme.typography.xs),
                Text('More dishes', style: context.theme.typography.xs),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
