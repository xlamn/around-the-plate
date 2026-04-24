import 'dart:io';

import 'package:app_theme/app_theme.dart';
import 'package:directory_image_storage_api/directory_image_storage_api.dart';
import 'package:dishes_api/dishes_api.dart';
import 'package:flutter/material.dart';

import '../../../widgets/dish_rating.dart';
import '../../dish_details/view/dish_details_page.dart';

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
          borderRadius: .circular(AppSizes.radiusM),
          border: Border.all(
            color: context.theme.colors.border,
            width: 0.5,
          ),
        ),
        margin: const .symmetric(horizontal: AppSizes.spacing16),
        padding: const .all(AppSizes.spacing16),
        child: Row(
          mainAxisSize: .min,
          spacing: AppSizes.spacing12,
          children: <Widget>[
            SizedBox(
              width: 80,
              height: 80,
              child: ClipRRect(
                borderRadius: .circular(AppSizes.radiusM),
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
                      fontWeight: .w700,
                    ),
                    textAlign: .center,
                    maxLines: 1,
                    overflow: .ellipsis,
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
                        fontWeight: .w500,
                      ),
                    ),
                ],
              ),
            ),
            SizedBox(
              width: 80,
              child: Center(
                child: DishRating(
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
