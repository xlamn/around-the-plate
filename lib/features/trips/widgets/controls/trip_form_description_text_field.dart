import 'package:app_theme/app_theme.dart';
import 'package:flutter/material.dart';

class TripFormDescriptionTextField extends StatelessWidget {
  final TextEditingController controller;

  const TripFormDescriptionTextField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return FTextFormField(
      control: FTextFieldControl.managed(controller: controller),
      label: const Text('Description'),
      hint: 'A summer vacation...',
      maxLines: 3,
      textCapitalization: .sentences,
    );
  }
}
