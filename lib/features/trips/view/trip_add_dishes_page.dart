import 'package:app_theme/app_theme.dart';
import 'package:dishes_repository/dishes_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trips_repository/trips_repository.dart';

import '../../../features/dishes_overview/widgets/dish_card.dart';
import '../cubits/trip_add_dishes/trip_add_dishes_cubit.dart';
import '../widgets/trip_context_banner.dart';

class TripAddDishesPage extends StatelessWidget {
  final Trip trip;

  const TripAddDishesPage({super.key, required this.trip});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => TripAddDishesCubit(
        dishesRepository: context.read<DishesRepository>(),
        tripsRepository: context.read<TripsRepository>(),
        initialSelectedIds: Set.from(trip.dishIds),
      )..loadDishes(),
      child: TripAddDishesView(trip: trip),
    );
  }
}

class TripAddDishesView extends StatelessWidget {
  final Trip trip;

  const TripAddDishesView({super.key, required this.trip});

  @override
  Widget build(BuildContext context) {
    return BlocListener<TripAddDishesCubit, TripAddDishesState>(
      listenWhen: (_, current) => current.status == TripAddDishesStatus.saved,
      listener: (context, _) => Navigator.pop(context, true),
      child: BlocBuilder<TripAddDishesCubit, TripAddDishesState>(
        builder: (context, state) {
          return Scaffold(
            backgroundColor: context.theme.colors.background,
            appBar: AppBar(
              backgroundColor: context.theme.colors.background,
              surfaceTintColor: Colors.transparent,
              leading: IconButton(
                icon: const Icon(FIcons.arrowLeft),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            body: Column(
              children: [
                TripContextBanner(
                  trip: trip,
                  selectedCount: state.selectedDishIds.length,
                ),
                Expanded(
                  child: state.dishes.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                FIcons.utensils,
                                size: 48,
                                color: context.theme.colors.mutedForeground,
                              ),
                              const SizedBox(height: AppSizes.spacing12),
                              Text(
                                'No dishes yet',
                                style: context.theme.typography.md.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: AppSizes.spacing4),
                              Text(
                                'Add some dishes first to include them in this trip.',
                                style: context.theme.typography.sm.copyWith(
                                  color: context.theme.colors.mutedForeground,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        )
                      : ListView.separated(
                          padding: const .symmetric(vertical: AppSizes.spacing16),
                          itemCount: state.dishes.length,
                          separatorBuilder: (_, __) => const SizedBox(height: AppSizes.spacing12),
                          itemBuilder: (_, i) {
                            final dish = state.dishes.elementAt(i);
                            return DishCard(
                              dish: dish,
                              isSelected: state.selectedDishIds.contains(dish.id),
                              onToggle: () =>
                                  context.read<TripAddDishesCubit>().toggleDish(dish.id),
                            );
                          },
                        ),
                ),
              ],
            ),
            bottomNavigationBar: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.spacing16,
                  vertical: AppSizes.spacing12,
                ),
                child: FButton(
                  onPress: state.isSaving
                      ? null
                      : () => context.read<TripAddDishesCubit>().saveDishes(trip),
                  child: Text(
                    state.isSaving ? 'Saving...' : 'Save',
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
