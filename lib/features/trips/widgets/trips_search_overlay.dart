import 'dart:ui';

import 'package:app_theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trips_api/trips_api.dart';

import '../cubits/trips_search/trips_search_cubit.dart';
import 'trip_card.dart';

class TripsSearchOverlay extends StatelessWidget {
  final List<Trip> trips;

  const TripsSearchOverlay({super.key, required this.trips});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => TripsSearchCubit(trips),
      child: const TripsSearchOverlayView(),
    );
  }
}

class TripsSearchOverlayView extends StatefulWidget {
  const TripsSearchOverlayView({super.key});

  @override
  State<TripsSearchOverlayView> createState() => _TripsSearchOverlayViewState();
}

class _TripsSearchOverlayViewState extends State<TripsSearchOverlayView> {
  late final TextEditingController _controller;
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _controller.addListener(_onTextChanged);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
        child: Container(
          color: context.theme.colors.background.withValues(alpha: 0.8),
          child: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const .symmetric(vertical: AppSizes.spacing16),
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
                                onChanged: (query) =>
                                    context.read<TripsSearchCubit>().search(query),
                                decoration: InputDecoration(
                                  hintText: 'Search trips...',
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
                            if (_hasText)
                              GestureDetector(
                                onTap: () {
                                  _controller.clear();
                                  context.read<TripsSearchCubit>().search('');
                                },
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
                  child: BlocBuilder<TripsSearchCubit, TripsSearchState>(
                    builder: (context, state) {
                      if (state.query.trim().isEmpty) {
                        return GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () => Navigator.of(context).pop(),
                          child: const SizedBox.expand(),
                        );
                      }
                      if (state.filteredTrips.isEmpty) {
                        return Center(
                          child: Text(
                            'No trips found',
                            style: context.theme.typography.sm.copyWith(
                              color: context.theme.colors.mutedForeground,
                            ),
                          ),
                        );
                      }
                      return GridView.builder(
                        padding: const .all(AppSizes.spacing16),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: AppSizes.spacing12,
                          mainAxisSpacing: AppSizes.spacing12,
                          childAspectRatio: 0.75,
                        ),
                        itemCount: state.filteredTrips.length,
                        itemBuilder: (_, i) => TripCard(
                          trip: state.filteredTrips.elementAt(i),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onTextChanged() {
    final hasText = _controller.text.isNotEmpty;
    if (hasText != _hasText) setState(() => _hasText = hasText);
  }

  @override
  void dispose() {
    _controller.removeListener(_onTextChanged);
    _controller.dispose();
    super.dispose();
  }
}
