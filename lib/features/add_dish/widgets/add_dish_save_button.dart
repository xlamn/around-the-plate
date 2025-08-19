import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forui/forui.dart';

import '../../../models/dish.dart';
import '../cubits/add_dish/add_dish_cubit.dart';

class AddDishSaveButton extends StatelessWidget {
  final Dish dish;

  const AddDishSaveButton({super.key, required this.dish});

  @override
  Widget build(BuildContext context) {
    return FButton(
      onPress: () {
        context.read<AddDishCubit>().addDish(dish);
      },
      child: const Text("Add Dish"),
    );
  }
}
