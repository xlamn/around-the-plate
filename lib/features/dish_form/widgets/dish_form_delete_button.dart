import 'package:dishes_api/dishes_api.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forui/forui.dart';

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
      style: FButtonStyle.ghost(),
      onPress: () async {
        await showFDialog(
          context: context,
          builder: (_, style, animation) {
            return FDialog(
              direction: Axis.horizontal,
              body: Text('Are you sure you want to delete this dish?'),
              actions: [
                FButton(
                  style: FButtonStyle.destructive(),
                  onPress: () async {
                    await context.read<DishFormCubit>().deleteDish(dish);
                    if (!context.mounted) return;
                    Navigator.pop(context);
                  },
                  child: Text('Delete Dish'),
                ),
                FButton(
                  style: FButtonStyle.ghost(),
                  onPress: () => Navigator.pop(context),
                  child: Text('Cancel'),
                ),
              ],
            );
          },
        );
      },
      child: Text("Delete Dish"),
    );
  }
}
