import 'package:app_theme/app_theme.dart';
import 'package:flutter/widgets.dart';

class DishFormSaveButton extends StatelessWidget {
  final bool isEditing;

  final Future<void> Function() onPressed;

  const DishFormSaveButton({
    super.key,
    required this.onPressed,
    this.isEditing = false,
  });

  @override
  Widget build(BuildContext context) {
    return FButton(
      onPress: onPressed,
      child: Text(isEditing ? "Edit Dish" : "Add Dish"),
    );
  }
}
