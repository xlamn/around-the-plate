import 'package:directory_image_storage_api/directory_image_storage_api.dart';
import 'package:dishes_repository/dishes_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../dish_form/view/dish_form_bottom_sheet.dart';
import '../cubit/dish_details_cubit.dart';

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
    return Scaffold(
      appBar: AppBar(),
      body: BlocBuilder<DishDetailsCubit, DishDetailsState>(
        builder: (context, state) {
          switch (state.status) {
            case DishDetailsStatus.loading:
              return const Center(child: CircularProgressIndicator());
            case DishDetailsStatus.failure:
              return const Center(child: Text('Failed to load dish.'));
            case DishDetailsStatus.notFound:
              return const Center(child: Text('Dish not found.'));
            case DishDetailsStatus.success:
              final dish = state.dish!;
              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.file(
                        imageStorage.getImageFile(dish.imagePath)!,
                        height: 100,
                        width: 100,
                      ),
                    ),
                    const SizedBox(height: 32),
                    Text(
                      dish.name,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),
                    Text('${dish.rating * 10}/10'),
                    const SizedBox(height: 16),
                    if (dish.cuisineValue != null) Text(dish.cuisine!.name),
                    if (dish.category != null) Text(dish.category!.name),
                    const SizedBox(height: 16),
                    if (dish.date != null) Text('${dish.date}'),
                    if (dish.location != null)
                      Text('${dish.location?.placeName}'),
                    const SizedBox(height: 16),
                    Text('${dish.lastModifiedDate}'),
                    const SizedBox(height: 32),
                    TextButton(
                      onPressed: () async {
                        await showModalBottomSheet(
                          context: context,
                          isDismissible: false,
                          enableDrag: false,
                          isScrollControlled: true,
                          builder: (_) => DishFormBottomSheet(
                            initialDish: dish,
                          ),
                        );

                        if (!context.mounted) return;
                        await context.read<DishDetailsCubit>().refreshDish();
                      },
                      child: const Text('Edit Dish'),
                    ),
                  ],
                ),
              );
            default:
              return const SizedBox.shrink();
          }
        },
      ),
    );
  }
}
