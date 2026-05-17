import 'package:app_theme/app_theme.dart';
import 'package:flutter/material.dart';

class TripFormNameTextField extends StatelessWidget {
  final TextEditingController controller;

  const TripFormNameTextField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return FTextFormField(
      control: FTextFieldControl.managed(controller: controller),
      label: const Text('Trip name *'),
      hint: 'Paris Trip',
      maxLines: 1,
      autovalidateMode: .onUnfocus,
      textCapitalization: .words,
      validator: (value) => (value?.isEmpty ?? true) ? 'Name is required' : null,
    );
  }
}
