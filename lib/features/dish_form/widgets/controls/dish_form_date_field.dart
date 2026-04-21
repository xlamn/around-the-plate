import 'package:app_theme/app_theme.dart';
import 'package:flutter/widgets.dart';

class DishFormDateField extends StatelessWidget {
  final FDateFieldController controller;

  const DishFormDateField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) => FDateField(
    control: FDateFieldControl.managed(controller: controller),
    label: const Text('Date'),
    clearable: true,
    canRequestFocus: false,
  );
}
