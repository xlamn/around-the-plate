import 'package:app_theme/app_theme.dart';
import 'package:flutter/material.dart';

class DishFormNameTextField extends StatelessWidget {
  final TextEditingController controller;

  const DishFormNameTextField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: FTextFormField(
        control: FTextFieldControl.managed(controller: controller),
        label: const Text('Name *'),
        hint: 'Spaghetti Carbonara',
        maxLines: 1,
        autovalidateMode: AutovalidateMode.onUnfocus,
        textCapitalization: TextCapitalization.words,
        validator: (value) =>
            (value?.isEmpty ?? true) ? 'Name is required' : null,
      ),
    );
  }
}
