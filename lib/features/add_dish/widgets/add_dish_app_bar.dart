import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

import '../../../models/dish.dart';
import 'add_dish_save_button.dart';

class AddDishAppBar extends StatelessWidget {
  final TextEditingController nameController;

  const AddDishAppBar({super.key, required this.nameController});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: const Icon(FIcons.x),
          onPressed: () => Navigator.of(context).pop(),
        ),
        AddDishSaveButton(
          dish: Dish(
            name: nameController.text,
            date: DateTime.now(),
            imagePath: '',
            origin: '',
            rating: 1.0,
          ),
        ),
      ],
    );
  }
}
