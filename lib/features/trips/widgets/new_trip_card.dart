import 'package:app_theme/app_theme.dart';
import 'package:flutter/widgets.dart';

class NewTripCard extends StatelessWidget {
  final VoidCallback onTap;

  const NewTripCard({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 140,
        decoration: BoxDecoration(
          color: context.theme.colors.muted,
          borderRadius: .circular(AppSizes.radiusM),
          border: Border.all(
            color: context.theme.colors.border,
            width: 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: .center,
          spacing: AppSizes.spacing8,
          children: [
            Icon(
              FIcons.plus,
              size: AppSizes.iconL,
              color: context.theme.colors.mutedForeground,
            ),
            Text(
              'New Trip',
              style: context.theme.typography.sm.copyWith(
                color: context.theme.colors.mutedForeground,
                fontWeight: .w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
