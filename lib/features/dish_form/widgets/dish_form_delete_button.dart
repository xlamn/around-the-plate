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
      variant: .destructive,
      onPress: () async {
        await showFDialog(
          context: context,
          builder: (_, style, animation) {
            return FDialog(
              animation: animation,
              builder: (dialogContext, style) {
                return Padding(
                  padding: const .all(AppSizes.spacing16),
                  child: Column(
                    crossAxisAlignment: .start,
                    mainAxisSize: .min,
                    spacing: AppSizes.spacing16,
                    children: [
                      DefaultTextStyle.merge(
                        style: style.bodyTextStyle,
                        child: const Text('Are you sure you want to delete this dish?'),
                      ),
                      Row(
                        mainAxisAlignment: .end,
                        spacing: AppSizes.spacing8,
                        children: [
                          FButton(
                            variant: .destructive,
                            onPress: () async {
                              await context.read<DishFormCubit>().deleteDish(dish);
                              if (!context.mounted) return;
                              Navigator.pop(context);
                            },
                            child: const Text('Delete Dish'),
                          ),
                          FButton(
                            variant: .ghost,
                            onPress: () => Navigator.pop(context),
                            child: const Text('Cancel'),
                          ),
                        ].toList(),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
      child: const Text('Delete Dish'),
    );
  }
}
