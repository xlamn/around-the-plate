import 'package:app_theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../extensions/strings_extension.dart';
import '../cubits/trips_sort/trips_sort_cubit.dart';
import '../models/trips_sort_option.dart';

class TripsOverviewSortButton extends StatefulWidget {
  const TripsOverviewSortButton({super.key});

  @override
  State<TripsOverviewSortButton> createState() => _TripsOverviewSortButtonState();
}

class _TripsOverviewSortButtonState extends State<TripsOverviewSortButton>
    with TickerProviderStateMixin {
  late final FPopoverController _popoverController = FPopoverController(vsync: this);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TripsSortCubit, TripsSortOption>(
      builder: (context, selectedOption) {
        return FPopoverMenu.tiles(
          control: FPopoverControl.managed(controller: _popoverController),
          menu: [
            FTileGroup(
              children: [
                for (final option in TripsSortOption.values)
                  FTile(
                    title: Text(option.label.toCapitalized()),
                    selected: option == selectedOption,
                    suffix: option == selectedOption ? const Icon(FIcons.check) : null,
                    onPress: () {
                      context.read<TripsSortCubit>().changeSort(option);
                      _popoverController.hide();
                    },
                  ),
              ],
            ),
          ],
          child: Container(
            foregroundDecoration: BoxDecoration(
              border: selectedOption != TripsSortOption.defaultOrder
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

  @override
  void dispose() {
    _popoverController.dispose();
    super.dispose();
  }
}
