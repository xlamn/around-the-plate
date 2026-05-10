import 'package:app_theme/app_theme.dart';
import 'package:around_the_plate/features/home_overview/widgets/home_search_overlay.dart';
import 'package:dishes_api/dishes_api.dart';
import 'package:flutter/material.dart';
import 'package:trips_api/trips_api.dart';

class HomeSearchBar extends StatelessWidget {
  final List<Dish> dishes;
  final List<Trip> trips;

  const HomeSearchBar({
    super.key,
    required this.dishes,
    required this.trips,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: .opaque,
      onTap: () => _openSearch(context),
      child: Hero(
        tag: 'home_search_bar',
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const .all(AppSizes.spacing12),
            decoration: BoxDecoration(
              color: context.theme.colors.muted,
              borderRadius: .circular(AppSizes.radiusM),
              border: .all(color: context.theme.colors.border, width: 0.2),
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
                  'Search dishes and trips...',
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
        pageBuilder: (_, __, ___) => HomeSearchOverlay(dishes: dishes, trips: trips),
        transitionsBuilder: (_, animation, __, child) => FadeTransition(
          opacity: CurvedAnimation(parent: animation, curve: Curves.easeOut),
          child: child,
        ),
      ),
    );
  }
}
