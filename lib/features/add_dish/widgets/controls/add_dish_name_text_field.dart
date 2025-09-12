import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

class AddDishNameTextField extends StatelessWidget {
  final TextEditingController controller;

  const AddDishNameTextField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: FTextFormField(
        controller: controller,
        label: const Text('Name *'),
        hint: 'Spaghetti Carbonara',
        maxLines: 1,
        autovalidateMode: AutovalidateMode.onUnfocus,
        validator: (value) =>
            (value?.isEmpty ?? true) ? 'Name is required' : null,
      ),
    );
  }
}
