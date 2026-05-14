import 'package:app_theme/app_theme.dart';
import 'package:around_the_plate/features/journey_overview/widgets/sections/journey_achievements_section.dart';
import 'package:dishes_repository/dishes_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trips_repository/trips_repository.dart';

import '../../achievements/achievements.dart';
import '../../trips/cubits/trips_overview/trips_overview_cubit.dart';
import '../cubits/journey_overview_cubit.dart';
import '../widgets/journey_header_cards.dart';
import '../widgets/sections/journey_map_section.dart';
import '../widgets/sections/journey_stats_section.dart';
import '../widgets/sections/journey_top_dishes_section.dart';
import '../widgets/subpages/journey_achievements_detail_page.dart';
import '../widgets/subpages/journey_map_detail_page.dart';
import '../widgets/subpages/journey_statistics_detail_page.dart';
import '../widgets/subpages/journey_top_dishes_detail_page.dart';

class JourneyOverviewPage extends StatelessWidget {
  const JourneyOverviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => JourneyOverviewCubit(
            dishesRepository: context.read<DishesRepository>(),
          )..load(),
        ),
        BlocProvider(
          create: (_) => AchievementsCubit(
            dishesRepository: context.read<DishesRepository>(),
          )..load(),
        ),
        BlocProvider(
          create: (_) => TripsOverviewCubit(
            tripsRepository: context.read<TripsRepository>(),
          )..loadTrips(),
        ),
      ],
      child: const JourneyOverviewView(),
    );
  }
}

class JourneyOverviewView extends StatelessWidget {
  const JourneyOverviewView({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<JourneyOverviewCubit>().state;
    final achievements = context.watch<AchievementsCubit>().state.achievements;
    final tripCount = context.watch<TripsOverviewCubit>().state.trips.length;

    if (state.status == JourneyOverviewStatus.loading ||
        state.status == JourneyOverviewStatus.initial) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (state.status == JourneyOverviewStatus.failure) {
      return const Scaffold(
        body: Center(child: Text('Failed to load journey data')),
      );
    }

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Column(
              spacing: AppSizes.spacing16,
              crossAxisAlignment: .start,
              children: [
                const FHeader(title: Text('Journey')),
                JourneyHeaderCards(stats: state.stats, tripCount: tripCount),
                Padding(
                  padding: const .only(bottom: AppSizes.spacing16),
                  child: Column(
                    spacing: AppSizes.spacing16,
                    children: [
                      JourneyMapSection(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const JourneyMapDetailPage(),
                          ),
                        ),
                      ),
                      JourneyTopDishesSection(
                        stats: state.stats,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => JourneyTopDishesDetailPage(stats: state.stats),
                          ),
                        ),
                      ),
                      JourneyStatsSection(
                        stats: state.stats,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => JourneyStatisticsDetailPage(stats: state.stats),
                          ),
                        ),
                      ),
                      JourneyAchievementsSection(
                        achievements: achievements,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => JourneyAchievementsDetailPage(
                              achievements: achievements,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
