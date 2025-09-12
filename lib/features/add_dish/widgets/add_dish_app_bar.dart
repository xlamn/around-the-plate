import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

import 'add_dish_save_button.dart';

class AddDishAppBar extends StatelessWidget {
  final Future<void> Function() onPressed;

  const AddDishAppBar({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: const Icon(FIcons.x),
          onPressed: () => Navigator.of(context).pop(),
        ),
        AddDishSaveButton(onPressed: onPressed),
      ],
    );
  }
}
