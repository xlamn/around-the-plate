import 'package:app_theme/app_theme.dart';
import 'package:flutter/material.dart';

import '../../dish_form/view/dish_form_bottom_sheet.dart';
import '../../image_picker/service/image_picker_service.dart';

class NewDishCard extends StatelessWidget {
  const NewDishCard({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _addDish(context),
      child: Padding(
        padding: const .symmetric(horizontal: AppSizes.spacing16),
        child: Container(
          padding: const .symmetric(
            horizontal: AppSizes.spacing16,
            vertical: AppSizes.spacing16,
          ),
          decoration: BoxDecoration(
            color: context.theme.colors.muted,
            borderRadius: .circular(AppSizes.radiusM),
            border: .all(color: context.theme.colors.border, width: 1),
          ),
          child: Row(
            mainAxisAlignment: .center,
            spacing: AppSizes.spacing12,
            children: [
              Icon(
                FIcons.plus,
                size: AppSizes.iconM,
                color: context.theme.colors.mutedForeground,
              ),
              Text(
                'Add new dish',
                style: context.theme.typography.sm.copyWith(
                  color: context.theme.colors.mutedForeground,
                  fontWeight: .w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _addDish(BuildContext context) async {
    final imagePath = await ImagePickerService.instance.pickImage(context);
    if (!context.mounted || imagePath == null) return;

    await showModalBottomSheet(
      context: context,
      isDismissible: false,
      enableDrag: false,
      isScrollControlled: true,
      builder: (_) => DishFormBottomSheet(imagePath: imagePath),
    );
  }
}
