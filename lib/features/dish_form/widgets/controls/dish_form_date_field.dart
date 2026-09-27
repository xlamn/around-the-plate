import 'package:app_theme/app_theme.dart';
import 'package:flutter/widgets.dart';

class DishFormDateField extends StatelessWidget {
  final FDateSelectionController<DateTime?> controller;

  const DishFormDateField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) => FDateField(
    selectionControl: FDateSelectionControl.managedSingle(controller: controller),
    label: const Text('Date'),
    clearable: true,
    canRequestFocus: false,
  );
}
