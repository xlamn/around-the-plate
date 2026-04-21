import 'package:app_theme/app_theme.dart';
import 'package:around_the_plate/extensions/extensions.dart';
import 'package:around_the_plate/features/dish_form/cubits/location_search/dish_form_location_search_cubit.dart';
import 'package:around_the_plate/services/location_service.dart';
import 'package:dishes_api/dishes_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DishFormLocationSelect extends StatelessWidget {
  final FSelectController<DishLocation> controller;

  const DishFormLocationSelect({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DishFormLocationSearchCubit(service: LocationService.instance)..init(),
      child: _DishFormLocationSelectView(controller: controller),
    );
  }
}

class _DishFormLocationSelectView extends StatelessWidget {
  final FSelectController<DishLocation> controller;

  const _DishFormLocationSelectView({required this.controller});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DishFormLocationSearchCubit, DishFormLocationSearchState>(
      builder: (context, state) {
        return FSelect<DishLocation>.searchBuilder(
          control: FSelectControl.managed(controller: controller),
          label: const Text('Location'),
          hint: 'Select location',
          clearable: true,
          format: (location) => location.placeName?.toCapitalized() ?? '',
          contentAnchor: AlignmentDirectional.bottomStart,
          fieldAnchor: AlignmentDirectional.topStart,
          filter: (query) => context.read<DishFormLocationSearchCubit>().search(query),
          contentBuilder: (context, query, locations) => [
            for (final location in locations)
              FSelectItem<DishLocation>(
                title: Text(location.placeName?.toCapitalized() ?? ''),
                value: location,
              ),
          ],
        );
      },
    );
  }
}
