import 'package:app_theme/app_theme.dart';
import 'package:around_the_plate/features/trips/widgets/trip_stats_chip.dart';
import 'package:directory_image_storage_api/directory_image_storage_api.dart';
import 'package:dishes_api/dishes_api.dart';
import 'package:dishes_repository/dishes_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:trips_repository/trips_repository.dart';

import '../../../features/dish_details/view/dish_details_page.dart';
import '../../../widgets/dish_rating.dart';
import '../../../widgets/glass_button.dart';
import '../cubits/trip_detail/trip_detail_cubit.dart';
import '../widgets/trip_form_bottom_sheet.dart';
import '../widgets/trip_placeholder.dart';
import 'trip_add_dishes_page.dart';

class TripDetailPage extends StatelessWidget {
  final int tripId;

  const TripDetailPage({super.key, required this.tripId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => TripDetailCubit(
        tripsRepository: context.read<TripsRepository>(),
        dishesRepository: context.read<DishesRepository>(),
      )..loadTrip(tripId),
      child: const TripDetailView(),
    );
  }
}

class TripDetailView extends StatelessWidget {
  const TripDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TripDetailCubit, TripDetailState>(
      builder: (context, state) {
        if (state.status == .success && state.trip != null) {
          return _TripDetailContent(trip: state.trip!, dishes: state.dishes);
        }
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(FIcons.arrowLeft),
            ),
          ),
          body: switch (state.status) {
            .loading => const Center(child: CircularProgressIndicator()),
            .failure => const Center(child: Text('Failed to load trip.')),
            .notFound => const Center(child: Text('Trip not found.')),
            _ => const SizedBox.shrink(),
          },
        );
      },
    );
  }
}

class _TripDetailContent extends StatelessWidget {
  final Trip trip;
  final List<Dish> dishes;

  const _TripDetailContent({required this.trip, required this.dishes});

  @override
  Widget build(BuildContext context) {
    final imageFile = trip.coverImagePath.isNotEmpty
        ? DirectoryImageStorageApi.instance.getImageFile(trip.coverImagePath)
        : null;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: .light,
        statusBarBrightness: .dark,
      ),
      child: Scaffold(
        backgroundColor: context.theme.colors.background,
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 280,
              pinned: true,
              automaticallyImplyLeading: false,
              backgroundColor: context.theme.colors.background,
              surfaceTintColor: Colors.transparent,
              leading: Padding(
                padding: const .all(AppSizes.spacing8),
                child: GlassButton(
                  icon: FIcons.arrowLeft,
                  onTap: () => Navigator.pop(context),
                ),
              ),
              actions: [
                Padding(
                  padding: const .all(AppSizes.spacing8),
                  child: GlassButton(
                    icon: FIcons.squarePen,
                    onTap: () => _openEdit(context),
                  ),
                ),
              ],
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    imageFile != null
                        ? Image.file(imageFile, fit: .cover)
                        : const TripPlaceholder(),
                    const DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Colors.transparent, Colors.black54],
                          stops: [0.5, 1.0],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SliverToBoxAdapter(
              child: Padding(
                padding: const .all(AppSizes.spacing24),
                child: Column(
                  crossAxisAlignment: .start,
                  spacing: AppSizes.spacing12,
                  children: [
                    Text(
                      trip.name,
                      style: context.theme.typography.xl2.copyWith(
                        fontWeight: .bold,
                        height: 1.1,
                        letterSpacing: -0.5,
                      ),
                    ),
                    if (trip.description != null && trip.description!.isNotEmpty)
                      Text(
                        trip.description!,
                        style: context.theme.typography.sm.copyWith(
                          color: context.theme.colors.mutedForeground,
                          height: 1.5,
                        ),
                      ),
                    Wrap(
                      spacing: AppSizes.spacing8,
                      runSpacing: AppSizes.spacing8,
                      children: [
                        TripStatsChip(
                          icon: FIcons.utensils,
                          label: '${dishes.length} ${dishes.length == 1 ? 'dish' : 'dishes'}',
                        ),
                        if (dishes.isNotEmpty)
                          TripStatsChip(
                            icon: FIcons.star,
                            label: 'Avg ${(_avgRating * 10).toStringAsFixed(1)}',
                          ),
                        TripStatsChip(
                          icon: FIcons.calendar,
                          label: DateFormat('dd MMM yyyy').format(trip.createdDate),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            if (dishes.isEmpty)
              SliverFillRemaining(
                hasScrollBody: false,
                child: Center(
                  child: Column(
                    mainAxisSize: .min,
                    spacing: AppSizes.spacing12,
                    children: [
                      const Spacer(),
                      Icon(
                        FIcons.planeTakeoff,
                        size: 48,
                        color: context.theme.colors.mutedForeground,
                      ),
                      Text(
                        'No dishes yet',
                        style: context.theme.typography.md.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Spacer(),
                      Padding(
                        padding: const .all(AppSizes.spacing16),
                        child: SafeArea(
                          child: FButton(
                            onPress: () => _openAddDishes(context),
                            child: const Text('Add'),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            if (dishes.isNotEmpty) ...[
              SliverPadding(
                padding: const .symmetric(
                  horizontal: AppSizes.spacing16,
                  vertical: AppSizes.spacing8,
                ),
                sliver: SliverToBoxAdapter(
                  child: Row(
                    mainAxisAlignment: .spaceBetween,
                    crossAxisAlignment: .center,
                    children: [
                      Text(
                        'Dishes',
                        style: context.theme.typography.lg.copyWith(
                          fontWeight: .bold,
                        ),
                      ),
                      TextButton.icon(
                        onPressed: () => _openAddDishes(context),
                        icon: const Icon(Icons.add_rounded, size: 18),
                        label: const Text('Add'),
                        style: TextButton.styleFrom(
                          foregroundColor: context.theme.colors.primary,
                          padding: const .symmetric(
                            horizontal: AppSizes.spacing12,
                            vertical: AppSizes.spacing4,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverPadding(
                padding: const .symmetric(
                  horizontal: AppSizes.spacing16,
                  vertical: AppSizes.spacing8,
                ),
                sliver: SliverList.separated(
                  itemCount: dishes.length,
                  separatorBuilder: (_, __) => const SizedBox(height: AppSizes.spacing8),
                  itemBuilder: (_, i) => _TripDishRow(
                    dish: dishes.elementAt(i),
                    onRemove: () => _confirmRemove(context, dishes.elementAt(i)),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  double get _avgRating {
    if (dishes.isEmpty) return 0;
    return dishes.fold(0.0, (sum, d) => sum + d.rating) / dishes.length;
  }

  Future<void> _openEdit(BuildContext context) async {
    final cubit = context.read<TripDetailCubit>();
    final result = await showModalBottomSheet<TripFormResult>(
      context: context,
      isScrollControlled: true,
      builder: (_) => TripFormBottomSheet(trip: trip),
    );
    if (result == .deleted) {
      if (context.mounted) Navigator.pop(context);
    } else if (result == .updated) {
      if (context.mounted) await cubit.loadTrip(trip.id);
    }
  }

  Future<void> _openAddDishes(BuildContext context) async {
    final cubit = context.read<TripDetailCubit>();
    final updated = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => TripAddDishesPage(trip: trip),
      ),
    );
    if (updated == true && context.mounted) {
      await cubit.loadTrip(trip.id);
    }
  }

  void _confirmRemove(BuildContext context, Dish dish) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Remove dish'),
        content: Text('Remove "${dish.name}" from this trip?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              context.read<TripDetailCubit>().removeDish(dish.id);
            },
            child: Text(
              'Remove',
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ),
        ],
      ),
    );
  }
}

class _TripDishRow extends StatelessWidget {
  final Dish dish;
  final VoidCallback onRemove;

  const _TripDishRow({required this.dish, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    final imageFile = DirectoryImageStorageApi.instance.getImageFile(dish.imagePath);

    return GestureDetector(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => DishDetailsPage(dishId: dish.id)),
      ),
      onLongPress: onRemove,
      child: Container(
        decoration: BoxDecoration(
          color: context.theme.colors.card,
          borderRadius: .circular(AppSizes.radiusM),
          border: .all(color: context.theme.colors.border, width: 0.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        padding: const .all(AppSizes.spacing12),
        child: Row(
          spacing: AppSizes.spacing12,
          children: [
            ClipRRect(
              borderRadius: .circular(AppSizes.radiusS),
              child: imageFile != null
                  ? Image.file(imageFile, width: 68, height: 68, fit: .cover)
                  : Container(
                      width: 68,
                      height: 68,
                      color: context.theme.colors.muted,
                      child: Icon(
                        FIcons.utensils,
                        size: AppSizes.iconM,
                        color: context.theme.colors.mutedForeground,
                      ),
                    ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: .start,
                spacing: AppSizes.spacing4,
                children: [
                  Text(
                    dish.name,
                    style: context.theme.typography.sm.copyWith(
                      fontWeight: .w600,
                      height: 1.2,
                    ),
                    maxLines: 1,
                    overflow: .ellipsis,
                  ),
                  if (dish.cuisine != null || dish.category != null)
                    Text(
                      [
                        if (dish.cuisine != null) dish.cuisine!.displayName,
                        if (dish.category != null) dish.category!.name,
                      ].join(' · '),
                      style: context.theme.typography.xs.copyWith(
                        color: context.theme.colors.mutedForeground,
                      ),
                      maxLines: 1,
                      overflow: .ellipsis,
                    ),
                  if (dish.date != null)
                    Text(
                      DateFormat('dd MMM yyyy').format(dish.date!),
                      style: context.theme.typography.xs.copyWith(
                        color: context.theme.colors.mutedForeground,
                      ),
                    ),
                ],
              ),
            ),
            DishRating(rating: dish.rating, fontSize: 16),
          ],
        ),
      ),
    );
  }
}
