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
        margin: const EdgeInsets.symmetric(horizontal: AppSizes.spacing16),
        padding: const EdgeInsets.all(AppSizes.spacing16),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SizedBox(
              width: 80,
              height: 80,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(AppSizes.radiusL),
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
                spacing: AppSizes.spacing8,
                children: [
                  Text(
                    dish.name,
                    style: context.theme.typography.lg.copyWith(
                      height: 1.0,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  if (dish.cuisine != null)
                    Text(
                      dish.cuisine!.displayName,
                      style: context.theme.typography.xs.copyWith(
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  if (dish.date != null)
                    Text(
                      '${dish.date?.day}.${dish.date?.month}.${dish.date?.year}',
                      style: context.theme.typography.xs.copyWith(
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
