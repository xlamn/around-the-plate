import 'package:app_theme/app_theme.dart';
import 'package:flutter/material.dart';

class TripPlaceholder extends StatelessWidget {
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;

  const TripPlaceholder({
    super.key,
    this.width,
    this.height,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        gradient: LinearGradient(
          begin: .topLeft,
          end: .bottomRight,
          colors: [
            context.theme.colors.primary.withValues(alpha: 0.6),
            context.theme.colors.primary.withValues(alpha: 0.2),
          ],
        ),
      ),
      child: Icon(
        FIcons.utensils,
        size: 32,
        color: context.theme.colors.primaryForeground.withValues(alpha: 0.8),
      ),
    );
  }
}
