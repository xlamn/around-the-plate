import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

import 'dish_form_save_button.dart';

class DishFormAppBar extends StatelessWidget {
  final bool isEditing;
  final Future<void> Function() onPressed;

  const DishFormAppBar({
    super.key,
    required this.isEditing,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: const Icon(FIcons.x),
          onPressed: () => Navigator.of(context).pop(),
        ),
        DishFormSaveButton(
          isEditing: isEditing,
          onPressed: onPressed,
        ),
      ],
    );
  }
}
