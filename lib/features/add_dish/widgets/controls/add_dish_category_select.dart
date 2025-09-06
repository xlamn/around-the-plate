import 'package:dishes_api/dishes_api.dart';
import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

class AddDishCategorySelect extends StatelessWidget {
  final FSelectController<String> controller;

  const AddDishCategorySelect({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return FSelect<String>(
      controller: controller,
      label: const Text('Dish Category'),
      hint: 'Select a category',
      format: (s) => s,
      children: [
        for (final category in DishCategory.values)
          FSelectItem(category.name, category),
      ],
    );
  }
}
