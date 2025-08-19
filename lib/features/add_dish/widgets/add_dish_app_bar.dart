import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

class AddDishAppBar extends StatelessWidget {
  const AddDishAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: const Icon(FIcons.x),
          onPressed: () => Navigator.of(context).pop(),
        ),
        FButton(
          onPress: () {},
          child: const Text("Add Dish"),
        ),
      ],
    );
  }
}
