import 'package:app_theme/app_theme.dart';
import 'package:dishes_api/dishes_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trips_repository/trips_repository.dart';

import '../../../widgets/form_app_bar.dart';
import '../cubits/trips_overview/trips_overview_cubit.dart';
import '../widgets/trip_placeholder.dart';

class AddToTripBottomSheet extends StatefulWidget {
  final Dish dish;

  const AddToTripBottomSheet({super.key, required this.dish});

  @override
  State<AddToTripBottomSheet> createState() => _AddToTripBottomSheetState();
}

class _AddToTripBottomSheetState extends State<AddToTripBottomSheet> {
  bool _saving = false;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => TripsOverviewCubit(
        tripsRepository: context.read<TripsRepository>(),
      )..loadTrips(),
      child: SafeArea(
        child: Builder(
          builder: (context) {
            final trips = context.watch<TripsOverviewCubit>().state.trips;
            final alreadyIn = trips.where((t) => t.dishIds.contains(widget.dish.id)).toSet();

            return Container(
              decoration: BoxDecoration(
                color: context.theme.colors.background,
                borderRadius: const .vertical(
                  top: .circular(AppSizes.radiusL),
                ),
              ),
              child: Column(
                mainAxisSize: .min,
                children: [
                  FormAppBar(
                    onPressed: () async => Navigator.of(context).pop(),
                  ),
                  Padding(
                    padding: const .all(
                      AppSizes.spacing16,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Add to Trip',
                            style: context.theme.typography.xl.copyWith(
                              fontWeight: .bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (trips.isEmpty)
                    Padding(
                      padding: const .all(AppSizes.spacing32),
                      child: Text(
                        'No trips yet. Create one from the Home tab.',
                        style: context.theme.typography.sm.copyWith(
                          color: context.theme.colors.mutedForeground,
                        ),
                        textAlign: .center,
                      ),
                    )
                  else
                    Flexible(
                      child: ListView.separated(
                        shrinkWrap: true,
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSizes.spacing16,
                        ),
                        separatorBuilder: (_, __) => const SizedBox(height: AppSizes.spacing8),
                        itemCount: trips.length,
                        itemBuilder: (_, i) {
                          final trip = trips.elementAt(i);
                          final isIn = alreadyIn.contains(trip);
                          return _TripTile(
                            trip: trip,
                            isIn: isIn,
                            saving: _saving,
                            onToggle: () => _toggle(context, trip, isIn),
                          );
                        },
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> _toggle(BuildContext context, Trip trip, bool isIn) async {
    setState(() => _saving = true);
    final repo = context.read<TripsRepository>();
    if (isIn) {
      final updated = trip.copyWith(
        dishIds: trip.dishIds.where((id) => id != widget.dish.id).toList(),
      );
      await repo.saveTrip(updated);
    } else {
      final updated = trip.copyWith(dishIds: [...trip.dishIds, widget.dish.id]);
      await repo.saveTrip(updated);
    }
    if (mounted) setState(() => _saving = false);
  }
}

class _TripTile extends StatelessWidget {
  final Trip trip;
  final bool isIn;
  final bool saving;
  final VoidCallback onToggle;

  const _TripTile({
    required this.trip,
    required this.isIn,
    required this.saving,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onToggle,
      child: Container(
        padding: const .all(AppSizes.spacing12),
        decoration: BoxDecoration(
          color: isIn
              ? context.theme.colors.primary.withValues(alpha: 0.1)
              : context.theme.colors.muted,
          borderRadius: .circular(AppSizes.radiusM),
          border: .all(
            color: isIn ? context.theme.colors.primary : context.theme.colors.border,
            width: isIn ? 1.5 : 1,
          ),
        ),
        child: Row(
          spacing: AppSizes.spacing12,
          children: [
            ClipRRect(
              borderRadius: .circular(AppSizes.radiusS),
              child: TripPlaceholder(
                width: 44,
                height: 44,
                borderRadius: .circular(AppSizes.radiusS),
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: .start,
                spacing: 2,
                children: [
                  Text(
                    trip.name,
                    style: context.theme.typography.sm.copyWith(
                      fontWeight: .w600,
                    ),
                    maxLines: 1,
                    overflow: .ellipsis,
                  ),
                  Text(
                    '${trip.dishIds.length} ${trip.dishIds.length == 1 ? 'dish' : 'dishes'}',
                    style: context.theme.typography.xs.copyWith(
                      color: context.theme.colors.mutedForeground,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              isIn ? Icons.check_circle : Icons.circle_outlined,
              color: isIn ? context.theme.colors.primary : context.theme.colors.mutedForeground,
            ),
          ],
        ),
      ),
    );
  }
}
