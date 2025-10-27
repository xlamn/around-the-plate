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
      spacing: 8,
      children: [
        if (imageFile != null)
          SizedBox(
            width: 180,
            height: 160,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.file(imageFile, fit: BoxFit.cover),
            ),
          ),
        const Spacer(),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Center(
            child: Text(
              dish.name,
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        if (dish.cuisineValue != null ||
            dish.categoryValue != null ||
            dish.date != null ||
            dish.location != null)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Container(
              decoration: BoxDecoration(
                color: context.theme.cardStyle.decoration.color,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: context.theme.colors.primary.withValues(alpha: 0.2),
                    blurRadius: 10,
                    offset: const Offset(8, 8),
                  ),
                ],
              ),
              margin: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  spacing: 16,
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
                        value:
                            '${dish.date?.day}.${dish.date?.month}.${dish.date?.year}',
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
            padding: const EdgeInsets.all(48.0),
            child: DishDetailsRating(rating: dish.rating),
          ),
        ),
        const Spacer(),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text(
              'Last modified: ${dish.lastModifiedDate.toLocal()}',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey,
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
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        spacing: 8,
        children: [
          Icon(icon, color: Theme.of(context).colorScheme.primary),
          Expanded(
            child: Text(
              label,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}
