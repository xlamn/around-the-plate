import 'package:around_the_plate/extensions/extensions.dart';
import 'package:dishes_api/dishes_api.dart';
import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

class AddDishCategorySelect extends StatelessWidget {
  final FSelectController<DishCategory> controller;

  const AddDishCategorySelect({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return FSelect<DishCategory>(
      controller: controller,
      label: const Text('Category'),
      hint: 'Select a category',
      clearable: true,
      format: (c) => c.name.toCapitalized(),
      children: [
        for (final category in DishCategory.values)
          FSelectItem(category.name.toCapitalized(), category),
      ],
    );
  }
}
