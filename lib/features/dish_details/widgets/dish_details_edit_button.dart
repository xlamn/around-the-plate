import 'package:app_theme/app_theme.dart';
import 'package:dishes_repository/dishes_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../dish_form/view/dish_form_bottom_sheet.dart';
import '../cubit/dish_details_cubit.dart';

class DishDetailsEditButton extends StatelessWidget {
  final Dish dish;

  const DishDetailsEditButton({super.key, required this.dish});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () async {
        final result = await showModalBottomSheet(
          context: context,
          isDismissible: false,
          enableDrag: false,
          isScrollControlled: true,
          builder: (_) => DishFormBottomSheet(dish: dish),
        );
        if (!context.mounted) return;
        if (result == DishFormResult.deleted) {
          Navigator.pop(context);
        } else if (result == DishFormResult.updated) {
          await context.read<DishDetailsCubit>().refreshDish();
        }
      },
      icon: const Icon(FIcons.squarePen),
    );
  }
}
