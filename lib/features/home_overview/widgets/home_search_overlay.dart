import 'dart:ui';

import 'package:app_theme/app_theme.dart';
import 'package:dishes_api/dishes_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trips_repository/trips_repository.dart';

import '../../dishes_overview/widgets/dish_card.dart';
import '../../trips/widgets/trip_card.dart';
import '../cubits/home_search/home_search_cubit.dart';

class HomeSearchOverlay extends StatelessWidget {
  final List<Dish> dishes;
  final List<Trip> trips;

  const HomeSearchOverlay({
    super.key,
    required this.dishes,
    required this.trips,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HomeSearchCubit(dishes, trips),
      child: const HomeSearchOverlayView(),
    );
  }
}

class HomeSearchOverlayView extends StatefulWidget {
  const HomeSearchOverlayView({super.key});

  @override
  State<HomeSearchOverlayView> createState() => _HomeSearchOverlayViewState();
}

class _HomeSearchOverlayViewState extends State<HomeSearchOverlayView> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _controller.removeListener(_onTextChanged);
    _controller.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    context.read<HomeSearchCubit>().search(_controller.text);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeSearchCubit, HomeSearchState>(
      builder: (context, state) {
        final hasText = state.query.trim().isNotEmpty;
        return Scaffold(
          backgroundColor: Colors.transparent,
          body: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
            child: Container(
              color: context.theme.colors.background.withValues(alpha: 0.85),
              child: SafeArea(
                child: Column(
                  children: [
                    Padding(
                      padding: const .symmetric(vertical: AppSizes.spacing16),
                      child: Hero(
                        tag: 'home_search_bar',
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
                                GestureDetector(
                                  onTap: () => Navigator.of(context).pop(),
                                  child: Icon(
                                    Icons.arrow_back,
                                    size: AppSizes.iconM,
                                    color: context.theme.colors.mutedForeground,
                                  ),
                                ),
                                Expanded(
                                  child: TextField(
                                    autofocus: true,
                                    controller: _controller,
                                    decoration: InputDecoration(
                                      hintText: 'Search dishes and trips...',
                                      hintStyle: context.theme.typography.sm.copyWith(
                                        color: context.theme.colors.mutedForeground,
                                      ),
                                      border: .none,
                                      contentPadding: .zero,
                                      isDense: true,
                                    ),
                                    style: context.theme.typography.sm,
                                  ),
                                ),
                                if (hasText)
                                  GestureDetector(
                                    onTap: () => _controller.clear(),
                                    child: Icon(
                                      Icons.close,
                                      size: AppSizes.iconM,
                                      color: context.theme.colors.mutedForeground,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: hasText
                          ? _buildResults(context, state)
                          : GestureDetector(
                              behavior: .opaque,
                              onTap: () => Navigator.of(context).pop(),
                              child: const SizedBox.expand(),
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

  Widget _buildResults(BuildContext context, HomeSearchState state) {
    if (state.filteredDishes.isEmpty && state.filteredTrips.isEmpty) {
      return Center(
        child: Text(
          'No results found',
          style: context.theme.typography.sm.copyWith(
            color: context.theme.colors.mutedForeground,
          ),
        ),
      );
    }

    return ListView(
      padding: const .symmetric(vertical: AppSizes.spacing8),
      children: [
        if (state.filteredTrips.isNotEmpty) ...[
          Column(
            crossAxisAlignment: .start,
            spacing: AppSizes.spacing12,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.spacing16,
                ),
                child: Text(
                  'Trips',
                  style: context.theme.typography.sm.copyWith(
                    color: context.theme.colors.mutedForeground,
                    fontWeight: .w600,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              SizedBox(
                height: 200,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const .symmetric(horizontal: AppSizes.spacing16),
                  separatorBuilder: (_, __) => const SizedBox(width: AppSizes.spacing12),
                  itemCount: state.filteredTrips.length,
                  itemBuilder: (_, i) => TripCard(trip: state.filteredTrips.elementAt(i)),
                ),
              ),
            ],
          ),

          const SizedBox(height: AppSizes.spacing16),
        ],
        if (state.filteredDishes.isNotEmpty) ...[
          Column(
            crossAxisAlignment: .start,
            spacing: AppSizes.spacing12,
            children: [
              Padding(
                padding: const .symmetric(
                  horizontal: AppSizes.spacing16,
                ),
                child: Text(
                  'Dishes',
                  style: context.theme.typography.sm.copyWith(
                    color: context.theme.colors.mutedForeground,
                    fontWeight: .w600,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              ...List.generate(
                state.filteredDishes.length,
                (i) => Padding(
                  padding: const .only(bottom: AppSizes.spacing16),
                  child: DishCard(dish: state.filteredDishes.elementAt(i)),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}
