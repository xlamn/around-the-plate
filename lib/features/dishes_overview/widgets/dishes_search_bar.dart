import 'package:app_theme/app_theme.dart';
import 'package:dishes_api/dishes_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubits/dishes_data/dishes_overview_cubit.dart';
import 'dishes_search_overlay.dart';

class DishesSearchBar extends StatelessWidget {
  const DishesSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DishesOverviewCubit, DishesOverviewState>(
      buildWhen: (prev, curr) => prev.dishes != curr.dishes,
      builder: (context, state) {
        return GestureDetector(
          behavior: .opaque,
          onTap: () => _openSearch(context, state.dishes),
          child: Hero(
            tag: 'dishes_search_bar',
            child: Material(
              color: Colors.transparent,
              child: Container(
                margin: const .symmetric(horizontal: AppSizes.spacing16),
                padding: const .all(AppSizes.spacing12),
                decoration: BoxDecoration(
                  color: context.theme.colors.muted,
                  borderRadius: .circular(AppSizes.radiusM),
                  border: Border.all(
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
                      'Search dishes...',
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
      },
    );
  }

  void _openSearch(BuildContext context, List<Dish> dishes) {
    Navigator.push(
      context,
      PageRouteBuilder(
        opaque: false,
        transitionDuration: const Duration(milliseconds: 500),
        reverseTransitionDuration: const Duration(milliseconds: 250),
        pageBuilder: (context, _, __) => DishesSearchOverlay(dishes: dishes),
        transitionsBuilder: (context, animation, _, child) => FadeTransition(
          opacity: CurvedAnimation(parent: animation, curve: Curves.easeOut),
          child: child,
        ),
      ),
    );
  }
}
