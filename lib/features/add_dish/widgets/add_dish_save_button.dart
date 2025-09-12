import 'package:flutter/widgets.dart';
import 'package:forui/forui.dart';

class AddDishSaveButton extends StatelessWidget {
  final Future<void> Function() onPressed;

  const AddDishSaveButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return FButton(
      onPress: onPressed,
      child: const Text("Add Dish"),
    );
  }
}
