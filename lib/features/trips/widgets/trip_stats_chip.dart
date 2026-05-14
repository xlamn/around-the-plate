import 'package:app_theme/app_theme.dart';
import 'package:flutter/widgets.dart';

class TripStatsChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const TripStatsChip({
    super.key,
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const .symmetric(
        horizontal: AppSizes.spacing12,
        vertical: AppSizes.spacing8,
      ),
      decoration: BoxDecoration(
        color: context.theme.colors.muted,
        borderRadius: .circular(AppSizes.radiusM),
        border: .all(color: context.theme.colors.border, width: 0.5),
      ),
      child: Row(
        mainAxisSize: .min,
        spacing: AppSizes.spacing4,
        children: [
          Icon(icon, size: 14, color: context.theme.colors.mutedForeground),
          Text(
            label,
            style: context.theme.typography.xs.copyWith(
              color: context.theme.colors.mutedForeground,
              fontWeight: .w500,
            ),
          ),
        ],
      ),
    );
  }
}
