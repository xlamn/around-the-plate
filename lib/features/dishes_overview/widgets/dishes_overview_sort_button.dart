import 'package:app_theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../extensions/strings_extension.dart';
import '../cubits/dishes_sort/dishes_sort_cubit.dart';
import '../models/dishes_sort_option.dart';

class DishesOverviewSortButton extends StatelessWidget {
  const DishesOverviewSortButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DishesSortCubit, DishesSortOption>(
      builder: (context, selectedOption) {
        return FSelect<DishesSortOption>.rich(
          initialValue: selectedOption,
          format: (s) => s.label,
          builder: (_, _, _, field) {
            return Container(
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
                style: FButtonStyle.secondary(),
                onPress: () async {
                  (field as TextField).onTap!();
                },
                child: const Icon(FIcons.arrowUpDown),
              ),
            );
          },
          onChange: (value) {
            if (value != null) {
              context.read<DishesSortCubit>().changeSort(value);
            }
          },
          popoverConstraints: FPortalConstraints(
            maxWidth: MediaQuery.widthOf(context) * 0.4,
          ),
          children: [
            for (final option in DishesSortOption.values)
              FSelectItem(
                title: Text(option.label.toCapitalized()),
                value: option,
              ),
          ],
        );
      },
    );
  }
}
