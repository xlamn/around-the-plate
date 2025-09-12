import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

const countries = [
  'Vietnam',
  'United States',
  'Japan',
  'South Korea',
  'France',
  'Germany',
  'Italy',
  'Spain',
  'United Kingdom',
];

class AddDishOriginSelect extends StatelessWidget {
  final FSelectController<String> controller;

  const AddDishOriginSelect({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return FSelect<String>(
      controller: controller,
      label: const Text('Origin'),
      hint: 'Select an origin',
      format: (s) => s,
      clearable: true,
      children: [
        for (final country in countries) FSelectItem(country, country),
      ],
    );
  }
}
