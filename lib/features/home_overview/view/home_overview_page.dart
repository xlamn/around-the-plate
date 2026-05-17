import 'package:app_theme/app_theme.dart';
import 'package:around_the_plate/features/home_overview/widgets/home_header.dart';
import 'package:around_the_plate/features/home_overview/widgets/home_search_bar.dart';
import 'package:dishes_repository/dishes_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trips_repository/trips_repository.dart';

import '../../dishes_overview/cubits/dishes_data/dishes_overview_cubit.dart';
import '../../dishes_overview/view/dishes_overview_page.dart';
import '../../dishes_overview/widgets/dish_card.dart';
import '../../dishes_overview/widgets/new_dish_card.dart';
import '../../trips/cubits/trips_overview/trips_overview_cubit.dart';
import '../../trips/view/trips_overview_page.dart';
import '../../trips/widgets/new_trip_card.dart';
import '../../trips/widgets/trip_card.dart';
import '../../trips/widgets/trip_form_bottom_sheet.dart';

class HomeOverviewPage extends StatelessWidget {
  const HomeOverviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => DishesOverviewCubit(
            dishesRepository: context.read<DishesRepository>(),
          )..loadDishes(),
        ),
        BlocProvider(
          create: (_) => TripsOverviewCubit(
            tripsRepository: context.read<TripsRepository>(),
          )..loadTrips(),
        ),
      ],
      child: const HomeOverviewView(),
    );
  }
}

class HomeOverviewView extends StatelessWidget {
  const HomeOverviewView({super.key});

  @override
  Widget build(BuildContext context) {
    final dishState = context.watch<DishesOverviewCubit>().state;
    final tripState = context.watch<TripsOverviewCubit>().state;

    final dishes = dishState.dishes;
    final trips = tripState.trips;
    final recentDishes = dishes.reversed.take(5).toList();

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: .stretch,
              spacing: AppSizes.spacing12,
              children: [
                const HomeHeader(),
                Padding(
                  padding: const .symmetric(
                    horizontal: AppSizes.spacing16,
                  ),
                  child: HomeSearchBar(
                    dishes: dishes,
                    trips: trips,
                  ),
                ),
              ],
            ),
          ),

          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: .start,
              children: [
                Padding(
                  padding: const .symmetric(
                    horizontal: AppSizes.spacing16,
                    vertical: AppSizes.spacing12,
                  ),
                  child: Row(
                    mainAxisAlignment: .spaceBetween,
                    children: [
                      Text(
                        'Trips',
                        style: context.theme.typography.lg.copyWith(fontWeight: FontWeight.bold),
                      ),
                      if (trips.isNotEmpty)
                        GestureDetector(
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => const TripsOverviewPage()),
                          ),
                          child: Text(
                            'See all',
                            style: context.theme.typography.sm.copyWith(
                              color: context.theme.colors.primary,
                              fontWeight: .w500,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 200,
                  child: ListView.separated(
                    clipBehavior: .none,
                    scrollDirection: .horizontal,
                    padding: const .symmetric(horizontal: AppSizes.spacing16),
                    separatorBuilder: (_, __) => const SizedBox(width: AppSizes.spacing12),
                    itemCount: trips.length + 1,
                    itemBuilder: (_, i) {
                      if (i == trips.length) {
                        return NewTripCard(
                          onTap: () async => await showModalBottomSheet<TripFormResult>(
                            context: context,
                            isScrollControlled: true,
                            builder: (_) => const TripFormBottomSheet(),
                          ),
                        );
                      }
                      return TripCard(trip: trips.elementAt(i));
                    },
                  ),
                ),
              ],
            ),
          ),

          const SliverToBoxAdapter(
            child: SizedBox(height: AppSizes.spacing12),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const .symmetric(
                horizontal: AppSizes.spacing16,
                vertical: AppSizes.spacing12,
              ),
              child: Row(
                mainAxisAlignment: .spaceBetween,
                children: [
                  Text(
                    'Recent dishes',
                    style: context.theme.typography.lg.copyWith(
                      fontWeight: .bold,
                    ),
                  ),
                  if (dishes.isNotEmpty)
                    GestureDetector(
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const DishesOverviewPage()),
                      ),
                      child: Text(
                        'See all',
                        style: context.theme.typography.sm.copyWith(
                          color: context.theme.colors.primary,
                          fontWeight: .w500,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          SliverList.separated(
            itemCount: recentDishes.length + 1,
            separatorBuilder: (_, __) => const SizedBox(height: AppSizes.spacing16),
            itemBuilder: (_, i) {
              if (i < recentDishes.length) return DishCard(dish: recentDishes.elementAt(i));
              return const Padding(
                padding: .only(bottom: AppSizes.spacing16),
                child: NewDishCard(),
              );
            },
          ),
        ],
      ),
    );
  }
}
