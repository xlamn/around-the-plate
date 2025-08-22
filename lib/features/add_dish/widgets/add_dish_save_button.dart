import 'package:dishes_repository/dishes_repository.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forui/forui.dart';

import '../cubits/add_dish/add_dish_cubit.dart';

class AddDishSaveButton extends StatelessWidget {
  final Dish Function() getDish;

  const AddDishSaveButton({super.key, required this.getDish});

  @override
  Widget build(BuildContext context) {
    return FButton(
      onPress: () {
        context.read<AddDishCubit>().addDish(getDish());
      },
      child: const Text("Add Dish"),
    );
  }
}
