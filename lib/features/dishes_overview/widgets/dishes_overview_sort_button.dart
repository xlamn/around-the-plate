import 'package:app_theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../extensions/strings_extension.dart';
import '../cubits/dishes_sort/dishes_sort_cubit.dart';
import '../models/dishes_sort_option.dart';

class DishesOverviewSortButton extends StatefulWidget {
  const DishesOverviewSortButton({super.key});

  @override
  State<DishesOverviewSortButton> createState() => _DishesOverviewSortButtonState();
}

class _DishesOverviewSortButtonState extends State<DishesOverviewSortButton>
    with TickerProviderStateMixin {
  late final FPopoverController _popoverController = FPopoverController(vsync: this);

  @override
  void dispose() {
    _popoverController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DishesSortCubit, DishesSortOption>(
      builder: (context, selectedOption) {
        return FPopoverMenu.tiles(
          control: FPopoverControl.managed(controller: _popoverController),
          menu: [
            FTileGroup(
              children: [
                for (final option in DishesSortOption.values)
                  FTile(
                    title: Text(option.label.toCapitalized()),
                    selected: option == selectedOption,
                    suffix: option == selectedOption ? const Icon(FIcons.check) : null,
                    onPress: () {
                      context.read<DishesSortCubit>().changeSort(option);
                      _popoverController.hide();
                    },
                  ),
              ],
            ),
          ],
          child: Container(
            foregroundDecoration: BoxDecoration(
              border: selectedOption != DishesSortOption.defaultOrder
                  ? BoxBorder.all(
                      width: 2,
                      color: context.theme.colors.primary,
                    )
                  : null,
              borderRadius: BorderRadius.circular(AppSizes.spacing8),
            ),
            child: FButton.icon(
              variant: FButtonVariant.secondary,
              onPress: _popoverController.toggle,
              child: const Icon(FIcons.arrowUpDown),
            ),
          ),
        );
      },
    );
  }
}
