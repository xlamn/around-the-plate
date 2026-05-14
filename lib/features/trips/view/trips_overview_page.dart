import 'package:app_theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trips_repository/trips_repository.dart';

import '../cubits/trips_overview/trips_overview_cubit.dart';
import '../cubits/trips_sort/trips_sort_cubit.dart';
import '../extension/trips_extension.dart';
import '../models/trips_sort_option.dart';
import '../widgets/trip_card.dart';
import '../widgets/trip_form_bottom_sheet.dart';
import '../widgets/trips_overview_sort_button.dart';
import '../widgets/trips_search_bar.dart';

class TripsOverviewPage extends StatelessWidget {
  const TripsOverviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => TripsOverviewCubit(
            tripsRepository: context.read<TripsRepository>(),
          )..loadTrips(),
        ),
        BlocProvider(
          create: (_) => TripsSortCubit(),
        ),
      ],
      child: const TripsOverviewView(),
    );
  }
}

class TripsOverviewView extends StatelessWidget {
  const TripsOverviewView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        leading: IconButton(
          icon: const Icon(FIcons.arrowLeft),
          onPressed: () => Navigator.pop(context),
        ),
        title: BlocBuilder<TripsOverviewCubit, TripsOverviewState>(
          buildWhen: (prev, curr) => prev.trips != curr.trips,
          builder: (context, state) => TripsSearchBar(trips: state.trips),
        ),
        actions: const [
          TripsOverviewSortButton(),
          SizedBox(width: AppSizes.spacing16),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async => await showModalBottomSheet<TripFormResult>(
          context: context,
          isScrollControlled: true,
          builder: (_) => const TripFormBottomSheet(),
        ),
        backgroundColor: context.theme.colors.primary,
        child: Icon(FIcons.plus, color: context.theme.colors.primaryForeground),
      ),
      body: BlocBuilder<TripsOverviewCubit, TripsOverviewState>(
        builder: (context, state) {
          if (state.status == .loading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.status == .failure) {
            return const Center(child: Text('Failed to load trips'));
          }
          if (state.trips.isEmpty) {
            return const Center(
              child: Text('You haven\'t added any trips yet.'),
            );
          }
          return BlocBuilder<TripsSortCubit, TripsSortOption>(
            builder: (_, sortOption) {
              final trips = state.trips.sortedBy(sortOption);
              return GridView.builder(
                padding: const .all(AppSizes.spacing16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: AppSizes.spacing12,
                  mainAxisSpacing: AppSizes.spacing12,
                  childAspectRatio: 0.75,
                ),
                itemCount: trips.length,
                itemBuilder: (_, i) => TripCard(trip: trips.elementAt(i)),
              );
            },
          );
        },
      ),
    );
  }
}
