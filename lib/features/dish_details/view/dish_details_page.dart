import 'package:app_theme/app_theme.dart';
import 'package:directory_image_storage_api/directory_image_storage_api.dart';
import 'package:dishes_api/dishes_api.dart';
import 'package:dishes_repository/dishes_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../extensions/extensions.dart';
import '../cubit/dish_details_cubit.dart';
import '../widgets/dish_details_edit_button.dart';
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
  final imageStorage = DirectoryImageStorageApi.instance;

  const DishDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DishDetailsCubit, DishDetailsState>(
      builder: (context, state) {
        final hasDish = state.status == DishDetailsStatus.success;
        final dish = hasDish ? state.dish! : null;
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Icon(FIcons.arrowLeft),
            ),
            actions: [
              if (hasDish)
                DishDetailsEditButton(
                  dish: dish!,
                ),
            ],
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
            DishDetailsStatus.success => _DishDetailsContent(dish: dish!),
            _ => const SizedBox.shrink(),
          },
        );
      },
    );
  }
}

class _DishDetailsContent extends StatelessWidget {
  final Dish dish;

  const _DishDetailsContent({required this.dish});

  @override
  Widget build(BuildContext context) {
    final imageFile = DirectoryImageStorageApi.instance.getImageFile(
      dish.imagePath,
    );

    return Column(
      spacing: AppSizes.spacing8,
      children: [
        if (imageFile != null)
          SizedBox(
            width: 180,
            height: 160,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppSizes.radiusL),
              child: Image.file(imageFile, fit: BoxFit.cover),
            ),
          ),
        const Spacer(),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSizes.spacing8),
          child: Center(
            child: Text(
              dish.name,
              style: context.theme.typography.xl2.copyWith(
                fontWeight: FontWeight.bold,
                height: 1.0,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        if (dish.cuisineValue != null ||
            dish.categoryValue != null ||
            dish.date != null ||
            dish.location != null)
          Spacer(),
        if (dish.cuisineValue != null ||
            dish.categoryValue != null ||
            dish.date != null ||
            dish.location != null)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSizes.spacing8),
            child: Container(
              decoration: BoxDecoration(
                color: context.theme.colors.muted,
                borderRadius: BorderRadius.circular(AppSizes.radiusL),
                border: Border.all(width: 0.2),
                boxShadow: [
                  BoxShadow(
                    color: context.theme.colors.primary.withValues(alpha: 0.2),
                    blurRadius: 5,
                  ),
                ],
              ),
              margin: const EdgeInsets.symmetric(horizontal: AppSizes.spacing8),
              child: Padding(
                padding: const EdgeInsets.all(AppSizes.spacing16),
                child: Column(
                  spacing: AppSizes.spacing16,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (dish.cuisineValue != null)
                      _DishInfoRow(
                        icon: FIcons.cookingPot,
                        label: 'Cuisine',
                        value: dish.cuisine?.displayName ?? '',
                      ),
                    if (dish.categoryValue != null)
                      _DishInfoRow(
                        icon: FIcons.vegan,
                        label: 'Category',
                        value: dish.category?.name.toCapitalized() ?? '',
                      ),
                    if (dish.date != null)
                      _DishInfoRow(
                        icon: FIcons.calendar,
                        label: 'Date',
                        value: '${dish.date?.day}.${dish.date?.month}.${dish.date?.year}',
                      ),
                    if (dish.location != null)
                      _DishInfoRow(
                        icon: FIcons.locate,
                        label: 'Location',
                        value: dish.location?.placeName ?? '',
                      ),
                  ],
                ),
              ),
            ),
          ),
        const Spacer(),
        Center(
          child: Padding(
            padding: const EdgeInsets.all(AppSizes.spacing32),
            child: DishDetailsRating(rating: dish.rating),
          ),
        ),
        const Spacer(),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSizes.spacing8),
            child: Text(
              'Last modified: ${dish.lastModifiedDate.toLocal()}',
              style: context.theme.typography.xs.copyWith(
                color: context.theme.colors.mutedForeground,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _DishInfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _DishInfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSizes.spacing8),
      child: Row(
        spacing: AppSizes.spacing8,
        children: [
          Icon(icon, color: context.theme.colors.primary),
          Expanded(
            child: Text(
              label,
              style: context.theme.typography.sm.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              value,
              style: context.theme.typography.sm,
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}
