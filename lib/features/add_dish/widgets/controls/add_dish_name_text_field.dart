import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

class AddDishNameTextField extends StatelessWidget {
  final TextEditingController controller;

  const AddDishNameTextField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: FTextField(
        controller: controller,
        label: const Text('Name *'),
        hint: 'Spaghetti Carbonara',
        maxLines: 1,
      ),
    );
  }
}
