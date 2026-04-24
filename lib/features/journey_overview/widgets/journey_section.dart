import 'package:app_theme/app_theme.dart';
import 'package:flutter/material.dart';

class JourneySection extends StatelessWidget {
  final String title;
  final Widget child;
  final VoidCallback? onTap;

  const JourneySection({
    super.key,
    required this.title,
    required this.child,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: .start,
      spacing: AppSizes.spacing12,
      children: [
        InkWell(
          onTap: onTap,
          child: Padding(
            padding: const .symmetric(horizontal: AppSizes.spacing16, vertical: AppSizes.spacing8),
            child: Row(
              mainAxisAlignment: .spaceBetween,
              children: [
                Text(
                  title,
                  style: context.theme.typography.md.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (onTap != null)
                  GestureDetector(
                    onTap: onTap,
                    child: Icon(
                      FIcons.arrowRight,
                      color: context.theme.colors.mutedForeground,
                    ),
                  ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const .symmetric(
            horizontal: AppSizes.spacing16,
          ),
          child: child,
        ),
      ],
    );
  }
}
