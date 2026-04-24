import 'dart:io';

import 'package:app_theme/app_theme.dart';
import 'package:around_the_plate/widgets/dish_rating.dart';
import 'package:directory_image_storage_api/directory_image_storage_api.dart';
import 'package:dishes_api/dishes_api.dart';
import 'package:flutter/widgets.dart';

class JourneyDishRow extends StatelessWidget {
  final Dish dish;

  const JourneyDishRow({super.key, required this.dish});

  @override
  Widget build(BuildContext context) {
    final imageFile = DirectoryImageStorageApi.instance.getImageFile(dish.imagePath);

    return Padding(
      padding: const .only(bottom: AppSizes.spacing12),
      child: Row(
        spacing: AppSizes.spacing12,
        children: [
          ClipRRect(
            borderRadius: .circular(AppSizes.radiusS),
            child: imageFile != null
                ? Image.file(
                    File(imageFile.path),
                    width: 56,
                    height: 56,
                    fit: BoxFit.cover,
                  )
                : Container(
                    width: 56,
                    height: 56,
                    color: context.theme.colors.muted,
                    child: Icon(
                      FIcons.hamburger,
                      color: context.theme.colors.mutedForeground,
                    ),
                  ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: .start,
              children: [
                Text(
                  dish.name,
                  style: context.theme.typography.sm.copyWith(
                    fontWeight: .w600,
                  ),
                  maxLines: 1,
                  overflow: .ellipsis,
                ),
                if (dish.cuisine != null)
                  Text(
                    dish.cuisine!.displayName,
                    style: context.theme.typography.xs.copyWith(
                      color: context.theme.colors.mutedForeground,
                    ),
                  ),
              ],
            ),
          ),
          DishRating(
            rating: dish.rating,
            fontSize: 14,
          ),
        ],
      ),
    );
  }
}
