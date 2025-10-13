import 'package:around_the_plate/extensions/extensions.dart';
import 'package:dishes_api/dishes_api.dart';
import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

class AddDishCuisineSelect extends StatelessWidget {
  final FSelectController<DishCuisine> controller;

  const AddDishCuisineSelect({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return FSelect<DishCuisine>.rich(
      controller: controller,
      label: const Text('Cuisine'),
      hint: 'Select a cuisine',
      format: (c) => c.name.toCapitalized(),
      clearable: true,
      children: [
        for (final cuisine
            in DishCuisine.values.toList()
              ..sort((a, b) => a.name.compareTo(b.name)))
          FSelectItem(
            title: Text(cuisine.name.toCapitalized()),
            value: cuisine,
          ),
      ],
    );
  }
}
