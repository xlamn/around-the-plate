import 'package:flutter/widgets.dart';
import 'package:forui/forui.dart';

class AddDishDateField extends StatelessWidget {
  final FDateFieldController controller;

  const AddDishDateField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) => FDateField(
    controller: controller,
    label: const Text('Date'),
    clearable: true,
  );
}
