import 'dart:io';

import 'package:app_theme/app_theme.dart';
import 'package:directory_image_storage_api/directory_image_storage_api.dart';
import 'package:dishes_api/dishes_api.dart';
import 'package:flutter/material.dart';

import '../../dish_details/view/dish_details_page.dart';
import '../../dishes_overview/widgets/dish_card_rating.dart';

class DishCard extends StatelessWidget {
  final imageStorage = DirectoryImageStorageApi.instance;

  final Dish dish;

  const DishCard({super.key, required this.dish});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _openDetailsPage(context),
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
        margin: const EdgeInsets.symmetric(horizontal: 16.0),
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SizedBox(
              width: 80,
              height: 80,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.file(
                  File(
                    imageStorage.getImageFile(dish.imagePath)!.path,
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Expanded(
              child: Column(
                spacing: 8.0,
                children: [
                  Text(
                    dish.name,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  if (dish.cuisine != null)
                    Text(
                      dish.cuisine!.displayName,
                      style:
                          Theme.of(
                            context,
                          ).textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w400,
                          ),
                    ),
                  if (dish.date != null)
                    Text(
                      '${dish.date?.day}.${dish.date?.month}.${dish.date?.year}',
                      style:
                          Theme.of(
                            context,
                          ).textTheme.labelSmall?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                ],
              ),
            ),
            SizedBox(
              width: 80,
              child: Center(
                child: DishCardRating(
                  rating: dish.rating,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<String?> _openDetailsPage(BuildContext context) async {
    return Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => DishDetailsPage(
          dishId: dish.id,
        ),
      ),
    );
  }
}
