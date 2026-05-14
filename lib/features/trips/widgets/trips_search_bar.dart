import 'package:app_theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:trips_api/trips_api.dart';

import 'trips_search_overlay.dart';

class TripsSearchBar extends StatelessWidget {
  final List<Trip> trips;

  const TripsSearchBar({super.key, required this.trips});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: .opaque,
      onTap: () => _openSearch(context),
      child: Hero(
        tag: 'trips_search_bar',
        child: Material(
          color: Colors.transparent,
          child: Container(
            margin: const .symmetric(horizontal: AppSizes.spacing16),
            padding: const .all(AppSizes.spacing12),
            decoration: BoxDecoration(
              color: context.theme.colors.muted,
              borderRadius: .circular(AppSizes.radiusM),
              border: .all(
                color: context.theme.colors.border,
                width: 0.2,
              ),
            ),
            child: Row(
              spacing: AppSizes.spacing12,
              children: [
                Icon(
                  FIcons.search,
                  size: AppSizes.iconM,
                  color: context.theme.colors.mutedForeground,
                ),
                Text(
                  'Search trips...',
                  style: context.theme.typography.sm.copyWith(
                    color: context.theme.colors.mutedForeground,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _openSearch(BuildContext context) {
    Navigator.push(
      context,
      PageRouteBuilder(
        opaque: false,
        transitionDuration: const Duration(milliseconds: 500),
        reverseTransitionDuration: const Duration(milliseconds: 250),
        pageBuilder: (context, _, __) => TripsSearchOverlay(trips: trips),
        transitionsBuilder: (context, animation, _, child) => FadeTransition(
          opacity: CurvedAnimation(parent: animation, curve: Curves.easeOut),
          child: child,
        ),
      ),
    );
  }
}
