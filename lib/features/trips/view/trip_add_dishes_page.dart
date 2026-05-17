import 'package:app_theme/app_theme.dart';
import 'package:directory_image_storage_api/directory_image_storage_api.dart';
import 'package:dishes_api/dishes_api.dart';
import 'package:dishes_repository/dishes_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:trips_repository/trips_repository.dart';

import '../../../features/dishes_overview/cubits/dishes_data/dishes_overview_cubit.dart';
import '../../../widgets/dish_rating.dart';
import '../widgets/trip_placeholder.dart';

class TripAddDishesPage extends StatefulWidget {
  final Trip trip;

  const TripAddDishesPage({super.key, required this.trip});

  @override
  State<TripAddDishesPage> createState() => _TripAddDishesPageState();
}

class _TripAddDishesPageState extends State<TripAddDishesPage> {
  late Set<int> _selectedIds;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _selectedIds = Set.from(widget.trip.dishIds);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DishesOverviewCubit(
        dishesRepository: context.read<DishesRepository>(),
      )..loadDishes(),
      child: Builder(
        builder: (context) {
          final dishes = context.watch<DishesOverviewCubit>().state.dishes;

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
                _TripContextBanner(
                  trip: widget.trip,
                  selectedCount: _selectedIds.length,
                ),
                Expanded(
                  child: dishes.isEmpty
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
                          padding: const .all(
                            AppSizes.spacing16,
                          ),
                          itemCount: dishes.length,
                          separatorBuilder: (_, __) => const SizedBox(height: AppSizes.spacing12),
                          itemBuilder: (_, i) {
                            final dish = dishes.elementAt(i);
                            final selected = _selectedIds.contains(dish.id);
                            return _SelectableDishRow(
                              dish: dish,
                              selected: selected,
                              onToggle: () => setState(() {
                                if (selected) {
                                  _selectedIds.remove(dish.id);
                                } else {
                                  _selectedIds.add(dish.id);
                                }
                              }),
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
                  onPress: _saving ? null : () => _save(context),
                  child: Text(
                    _saving
                        ? 'Saving...'
                        : 'Save — ${_selectedIds.length} ${_selectedIds.length == 1 ? 'dish' : 'dishes'}',
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _save(BuildContext context) async {
    setState(() => _saving = true);
    final repo = context.read<TripsRepository>();
    final navigator = Navigator.of(context);
    final updatedTrip = widget.trip.copyWith(dishIds: _selectedIds.toList());
    await repo.saveTrip(updatedTrip);
    if (mounted) navigator.pop(true);
  }
}

class _TripContextBanner extends StatelessWidget {
  final Trip trip;
  final int selectedCount;

  const _TripContextBanner({required this.trip, required this.selectedCount});

  @override
  Widget build(BuildContext context) {
    final imageFile = trip.coverImagePath.isNotEmpty
        ? DirectoryImageStorageApi.instance.getImageFile(trip.coverImagePath)
        : null;

    return Container(
      margin: const .symmetric(horizontal: AppSizes.spacing16, vertical: AppSizes.spacing8),
      padding: const .all(AppSizes.spacing12),
      decoration: BoxDecoration(
        color: context.theme.colors.muted,
        borderRadius: .circular(AppSizes.radiusM),
        border: Border.all(color: context.theme.colors.border, width: 0.5),
      ),
      child: Row(
        spacing: AppSizes.spacing12,
        children: [
          ClipRRect(
            borderRadius: .circular(AppSizes.radiusS),
            child: imageFile != null
                ? Image.file(imageFile, width: 52, height: 52, fit: .cover)
                : TripPlaceholder(
                    width: 52,
                    height: 52,
                    borderRadius: .circular(AppSizes.radiusS),
                  ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: .start,
              spacing: AppSizes.spacing4,
              children: [
                Text(
                  trip.name,
                  style: context.theme.typography.sm.copyWith(fontWeight: .w600),
                  maxLines: 1,
                  overflow: .ellipsis,
                ),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: Align(
                    key: ValueKey(selectedCount),
                    alignment: .centerLeft,
                    child: Text(
                      selectedCount == 0
                          ? 'No dishes selected'
                          : '$selectedCount ${selectedCount == 1 ? 'dish' : 'dishes'} selected',
                      style: context.theme.typography.xs.copyWith(
                        color: selectedCount > 0
                            ? context.theme.colors.primary
                            : context.theme.colors.mutedForeground,
                        fontWeight: selectedCount > 0 ? .w500 : .w400,
                      ),
                    ),
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

class _SelectableDishRow extends StatelessWidget {
  final Dish dish;
  final bool selected;
  final VoidCallback onToggle;

  const _SelectableDishRow({
    required this.dish,
    required this.selected,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final imageFile = DirectoryImageStorageApi.instance.getImageFile(dish.imagePath);

    return GestureDetector(
      onTap: onToggle,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const .all(AppSizes.spacing12),
        decoration: BoxDecoration(
          color: selected
              ? context.theme.colors.primary.withValues(alpha: 0.08)
              : context.theme.colors.card,
          borderRadius: .circular(AppSizes.radiusM),
          border: .all(
            color: selected ? context.theme.colors.primary : context.theme.colors.border,
            width: selected ? 1.5 : 1.0,
          ),
        ),
        child: Row(
          spacing: AppSizes.spacing12,
          children: [
            ClipRRect(
              borderRadius: .circular(AppSizes.radiusS),
              child: imageFile != null
                  ? Image.file(imageFile, width: 64, height: 64, fit: .cover)
                  : Container(
                      width: 64,
                      height: 64,
                      color: context.theme.colors.muted,
                      child: Icon(FIcons.utensils, color: context.theme.colors.mutedForeground),
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
                      DateFormat('d MMM yyyy').format(dish.date!),
                      style: context.theme.typography.xs.copyWith(
                        color: context.theme.colors.mutedForeground,
                      ),
                    ),
                ],
              ),
            ),
            DishRating(rating: dish.rating, fontSize: 14),
            AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: .circle,
                color: selected ? context.theme.colors.primary : Colors.transparent,
                border: Border.all(
                  color: selected
                      ? context.theme.colors.primary
                      : context.theme.colors.mutedForeground,
                  width: 1.5,
                ),
              ),
              child: selected
                  ? Icon(
                      Icons.check_rounded,
                      size: 14,
                      color: context.theme.colors.primaryForeground,
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
