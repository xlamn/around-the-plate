import 'package:app_theme/app_theme.dart';
import 'package:dishes_repository/dishes_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubits/journey_overview_cubit.dart';
import '../widgets/journey_header_cards.dart';

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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const FHeader(title: Text('Journey')),
                JourneyHeaderCards(stats: state.stats),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
