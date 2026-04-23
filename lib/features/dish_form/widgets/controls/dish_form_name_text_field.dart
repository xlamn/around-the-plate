import 'package:app_theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cubits/dish_detection/dish_detection_cubit.dart';

class DishFormNameTextField extends StatelessWidget {
  final TextEditingController controller;

  const DishFormNameTextField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DishDetectionCubit, DishDetectionState>(
      builder: (context, state) {
        final hint = state.status == DishDetectionStatus.detected && state.name != null
            ? state.name!
            : 'Spaghetti Carbonara';

        return Flexible(
          child: FTextFormField(
            control: FTextFieldControl.managed(controller: controller),
            label: const Text('Name *'),
            hint: hint,
            maxLines: 1,
            autovalidateMode: AutovalidateMode.onUnfocus,
            textCapitalization: TextCapitalization.words,
            validator: (value) => (value?.isEmpty ?? true) ? 'Name is required' : null,
          ),
        );
      },
    );
  }
}
