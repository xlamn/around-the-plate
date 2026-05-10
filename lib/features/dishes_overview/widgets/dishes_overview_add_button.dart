import 'package:app_theme/app_theme.dart';
import 'package:flutter/material.dart';

import '../../dish_form/view/dish_form_bottom_sheet.dart';
import '../../image_picker/service/image_picker_service.dart';

class DishesOverviewAddButton extends StatelessWidget {
  final imagePickerService = ImagePickerService.instance;

  const DishesOverviewAddButton({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () async {
        final imagePath = await imagePickerService.pickImage(context);
        if (!context.mounted || imagePath == null) return;

        await showModalBottomSheet(
          context: context,
          isDismissible: false,
          enableDrag: false,
          isScrollControlled: true,
          builder: (_) => DishFormBottomSheet(imagePath: imagePath),
        );
      },
      backgroundColor: context.theme.colors.primary,
      child: Icon(FIcons.plus, color: context.theme.colors.primaryForeground),
    );
  }
}
