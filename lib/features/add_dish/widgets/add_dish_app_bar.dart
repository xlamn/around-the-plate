import 'package:dishes_repository/dishes_repository.dart';
import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

import 'add_dish_save_button.dart';

class AddDishAppBar extends StatelessWidget {
  final Dish Function() getDish;

  const AddDishAppBar({super.key, required this.getDish});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: const Icon(FIcons.x),
          onPressed: () => Navigator.of(context).pop(),
        ),
        AddDishSaveButton(getDish: getDish),
      ],
    );
  }
}
