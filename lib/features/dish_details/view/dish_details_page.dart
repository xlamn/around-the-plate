import 'package:app_theme/app_theme.dart';
import 'package:directory_image_storage_api/directory_image_storage_api.dart';
import 'package:dishes_api/dishes_api.dart';
import 'package:dishes_repository/dishes_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../extensions/extensions.dart';
import '../../../widgets/glass_button.dart';
import '../../dish_form/view/dish_form_bottom_sheet.dart';
import '../../trips/widgets/add_to_trip_bottom_sheet.dart';
import '../cubit/dish_details_cubit.dart';
import '../widgets/dish_details_rating.dart';

class DishDetailsPage extends StatelessWidget {
  final int dishId;

  const DishDetailsPage({super.key, required this.dishId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DishDetailsCubit(
        dishesRepository: context.read<DishesRepository>(),
      )..loadDish(dishId),
      child: const DishDetailsView(),
    );
  }
}

class DishDetailsView extends StatelessWidget {
  const DishDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DishDetailsCubit, DishDetailsState>(
      builder: (context, state) {
        if (state.status == DishDetailsStatus.success) {
          return _DishDetailsContent(dish: state.dish!);
        }
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(FIcons.arrowLeft),
            ),
          ),
          body: switch (state.status) {
            DishDetailsStatus.loading => const Center(
              child: CircularProgressIndicator(),
            ),
            DishDetailsStatus.failure => const Center(
              child: Text('Failed to load dish.'),
            ),
            DishDetailsStatus.notFound => const Center(
              child: Text('Dish not found.'),
            ),
            _ => const SizedBox.shrink(),
          },
        );
      },
    );
  }
}

class _DishDetailsContent extends StatefulWidget {
  final Dish dish;

  const _DishDetailsContent({required this.dish});

  @override
  State<_DishDetailsContent> createState() => _DishDetailsContentState();
}

class _DishDetailsContentState extends State<_DishDetailsContent>
    with SingleTickerProviderStateMixin {
  double _overlapHeight = 0;
  double _revealAmount = 0;

  // Current card translation: 0 = card at rest overlapping image,
  // _revealAmount = card dragged down to reveal more image.
  double _offset = 0;
  double _snapStart = 0;
  double _snapEnd = 0;

  late final AnimationController _snapController;

  @override
  void initState() {
    super.initState();
    _snapController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _snapController.addListener(_onSnapTick);
  }

  @override
  Widget build(BuildContext context) {
    final dish = widget.dish;
    final imageFile = DirectoryImageStorageApi.instance.getImageFile(
      dish.imagePath,
    );
    final hasMetadata =
        dish.cuisineValue != null ||
        dish.categoryValue != null ||
        dish.date != null ||
        dish.location != null;

    return AnnotatedRegion(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      child: Scaffold(
        body: LayoutBuilder(
          builder: (context, constraints) {
            _overlapHeight = constraints.maxHeight * 0.25;
            _revealAmount = constraints.maxHeight * 0.15;

            final imageSize = constraints.maxWidth;
            final cardTop = _overlapHeight + _offset;

            return Stack(
              children: [
                // Image
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  height: imageSize,
                  child: imageFile != null
                      ? Image.file(imageFile, fit: BoxFit.cover)
                      : const Placeholder(),
                ),

                // Card
                Positioned(
                  top: cardTop,
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: context.theme.colors.background,
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(AppSizes.radiusL),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onVerticalDragUpdate: _onDragUpdate,
                          onVerticalDragEnd: _onDragEnd,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: AppSizes.spacing16,
                            ),
                            child: Center(
                              child: Container(
                                width: 36,
                                height: 4,
                                decoration: BoxDecoration(
                                  color: context.theme.colors.border,
                                  borderRadius: BorderRadius.circular(AppSizes.radiusS),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: SingleChildScrollView(
                            physics: const NeverScrollableScrollPhysics(),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: AppSizes.spacing16,
                                horizontal: AppSizes.spacing24,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                spacing: AppSizes.spacing24,
                                children: withDividers(
                                  color: context.theme.colors.border,
                                  children: [
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      spacing: AppSizes.spacing16,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            dish.name,
                                            style: context.theme.typography.xl2.copyWith(
                                              fontWeight: FontWeight.bold,
                                              height: 1.25,
                                            ),
                                          ),
                                        ),
                                        DishDetailsRating(rating: dish.rating),
                                      ],
                                    ),

                                    if (hasMetadata)
                                      Column(
                                        children: [
                                          if (dish.cuisineValue != null)
                                            _InfoRow(
                                              icon: FIcons.cookingPot,
                                              label: 'Cuisine',
                                              value: dish.cuisine?.displayName ?? '',
                                            ),
                                          if (dish.categoryValue != null)
                                            _InfoRow(
                                              icon: FIcons.vegan,
                                              label: 'Category',
                                              value: dish.category?.name.toCapitalized() ?? '',
                                            ),
                                          if (dish.date != null)
                                            _InfoRow(
                                              icon: FIcons.calendar,
                                              label: 'Date',
                                              value:
                                                  '${dish.date?.day}.${dish.date?.month}.${dish.date?.year}',
                                            ),
                                          if (dish.location != null)
                                            _InfoRow(
                                              icon: FIcons.locate,
                                              label: 'Location',
                                              value: dish.location?.placeName ?? '',
                                            ),
                                        ],
                                      ),

                                    Center(
                                      child: Text(
                                        'Last modified: ${DateFormat.yMMMd().add_Hm().format(dish.lastModifiedDate)}',
                                        style: context.theme.typography.xs.copyWith(
                                          color: context.theme.colors.mutedForeground,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // NavBar
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: SafeArea(
                    bottom: false,
                    child: Padding(
                      padding: const .symmetric(
                        horizontal: AppSizes.spacing8,
                        vertical: AppSizes.spacing4,
                      ),
                      child: Row(
                        mainAxisAlignment: .spaceBetween,
                        children: [
                          GlassButton(
                            circular: true,
                            icon: FIcons.arrowLeft,
                            onTap: () => Navigator.pop(context),
                          ),
                          Row(
                            spacing: AppSizes.spacing8,
                            children: [
                              GlassButton(
                                circular: true,
                                icon: FIcons.ticketsPlane,
                                onTap: () => showModalBottomSheet<void>(
                                  context: context,
                                  isScrollControlled: true,
                                  builder: (_) => AddToTripBottomSheet(dish: widget.dish),
                                ),
                              ),
                              GlassButton(
                                circular: true,
                                icon: FIcons.squarePen,
                                onTap: () async {
                                  final result = await showModalBottomSheet<DishFormResult>(
                                    context: context,
                                    isDismissible: false,
                                    enableDrag: false,
                                    isScrollControlled: true,
                                    builder: (_) => DishFormBottomSheet(dish: widget.dish),
                                  );
                                  if (!context.mounted) return;
                                  if (result == DishFormResult.deleted) {
                                    Navigator.pop(context);
                                  } else if (result == DishFormResult.updated) {
                                    await context.read<DishDetailsCubit>().refreshDish();
                                  }
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  List<Widget> withDividers({required List<Widget> children, Color? color}) {
    return children
        .expand(
          (child) => [
            child,
            Divider(
              color: color,
            ),
          ],
        )
        .toList()
      ..removeLast();
  }

  @override
  void dispose() {
    _snapController
      ..removeListener(_onSnapTick)
      ..dispose();
    super.dispose();
  }

  void _onSnapTick() {
    setState(() {
      _offset = _snapStart + (_snapEnd - _snapStart) * _snapController.value;
    });
  }

  void _onDragUpdate(DragUpdateDetails details) {
    _snapController.stop();
    setState(() {
      _offset = (_offset + (details.primaryDelta ?? 0)).clamp(-_revealAmount, _revealAmount);
    });
  }

  void _onDragEnd(DragEndDetails details) {
    final velocity = details.primaryVelocity ?? 0;
    final double target;
    if (velocity > 200 || _offset > _revealAmount / 2) {
      target = _revealAmount;
    } else if (velocity < -200 || _offset < -_revealAmount / 2) {
      target = -_revealAmount;
    } else {
      target = 0.0;
    }
    _snapStart = _offset;
    _snapEnd = target;
    _snapController.forward(from: 0);
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSizes.spacing12),
      child: Row(
        spacing: AppSizes.spacing16,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: context.theme.colors.muted,
              borderRadius: BorderRadius.circular(AppSizes.radiusS),
            ),
            child: Icon(icon, size: 20),
          ),
          Expanded(
            flex: 3,
            child: Text(
              label,
              style: context.theme.typography.sm.copyWith(
                color: context.theme.colors.mutedForeground,
                height: 1,
              ),
            ),
          ),
          const Spacer(),
          Expanded(
            flex: 5,
            child: Text(
              value,
              style: context.theme.typography.sm.copyWith(
                fontWeight: FontWeight.w500,
                height: 1,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}
