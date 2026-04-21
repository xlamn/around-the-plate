import 'package:app_theme/app_theme.dart';
import 'package:dishes_api/dishes_api.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubits/dish_form_cubit.dart';

class DishFormDeleteButton extends StatelessWidget {
  final Dish dish;

  const DishFormDeleteButton({
    super.key,
    required this.dish,
  });

  @override
  Widget build(BuildContext context) {
    return FButton(
      variant: FButtonVariant.ghost,
      onPress: () async {
        await showFDialog(
          context: context,
          builder: (_, style, animation) {
            return FDialog(
              direction: Axis.horizontal,
              body: const Text('Are you sure you want to delete this dish?'),
              actions: [
                FButton(
                  variant: FButtonVariant.destructive,
                  onPress: () async {
                    await context.read<DishFormCubit>().deleteDish(dish);
                    if (!context.mounted) return;
                    Navigator.pop(context);
                  },
                  child: const Text('Delete Dish'),
                ),
                FButton(
                  variant: FButtonVariant.ghost,
                  onPress: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
              ],
            );
          },
        );
      },
      child: const Text('Delete Dish'),
    );
  }
}
