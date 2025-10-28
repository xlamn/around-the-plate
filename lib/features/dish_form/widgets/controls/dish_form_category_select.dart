import 'package:app_theme/app_theme.dart';
import 'package:around_the_plate/extensions/extensions.dart';
import 'package:dishes_api/dishes_api.dart';
import 'package:flutter/material.dart';

class DishFormCategorySelect extends StatelessWidget {
  final FSelectController<DishCategory> controller;

  const DishFormCategorySelect({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return FSelect<DishCategory>.rich(
      controller: controller,
      label: const Text('Category'),
      hint: 'Select a category',
      clearable: true,
      format: (c) => c.name.toCapitalized(),
      children: [
        for (final category in DishCategory.values)
          FSelectItem(
            title: Text(category.name.toCapitalized()),
            value: category,
          ),
      ],
    );
  }
}
