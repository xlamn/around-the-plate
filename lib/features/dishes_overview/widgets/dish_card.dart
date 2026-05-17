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
  final bool isSelected;
  final VoidCallback? onToggle;

  const DishCard({
    super.key,
    required this.dish,
    this.isSelected = false,
    this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final imageFile = imageStorage.getImageFile(dish.imagePath);

    return GestureDetector(
      onTap: onToggle ?? () => _openDetailsPage(context),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: .topLeft,
            end: .bottomRight,
            colors: [
              context.theme.colors.card,
              context.theme.colors.muted,
            ],
          ),
          borderRadius: .circular(AppSizes.radiusM),
          border: .all(
            color: isSelected ? context.theme.colors.primary : context.theme.colors.border,
            width: isSelected ? 1.5 : 0.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.18),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        margin: const .symmetric(horizontal: AppSizes.spacing16),
        padding: const .all(AppSizes.spacing16),
        child: Row(
          mainAxisSize: .min,
          spacing: AppSizes.spacing12,
          children: [
            SizedBox(
              width: 80,
              height: 80,
              child: ClipRRect(
                borderRadius: .circular(AppSizes.radiusM),
                child: imageFile != null
                    ? Image.file(File(imageFile.path), fit: .cover)
                    : Container(
                        color: context.theme.colors.muted,
                        child: Icon(FIcons.utensils, color: context.theme.colors.mutedForeground),
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
                        fontWeight: .w400,
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
                child: DishRating(rating: dish.rating),
              ),
            ),
            if (onToggle != null)
              AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected ? context.theme.colors.primary : Colors.transparent,
                  border: Border.all(
                    color: isSelected
                        ? context.theme.colors.primary
                        : context.theme.colors.mutedForeground,
                    width: 1.5,
                  ),
                ),
                child: isSelected
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

  Future<String?> _openDetailsPage(BuildContext context) async {
    return Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => DishDetailsPage(dishId: dish.id),
      ),
    );
  }
}
