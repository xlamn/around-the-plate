import 'package:app_theme/app_theme.dart';
import 'package:dishes_api/dishes_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

import '../cubits/map_controller/map_controller_cubit.dart';
import '../cubits/map_data/map_data_cubit.dart';
import '../cubits/map_interaction/map_interaction_cubit.dart';
import '../helpers/map_overview_controller.dart';
import '../widgets/country_map_details_dialog.dart';

class CountryMap extends StatelessWidget {
  const CountryMap({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<MapDataCubit, MapDataState>(
          listener: (context, state) {
            context.read<MapControllerCubit>().updateMap(
              state.countriesGeoJson ?? '',
              state.highlightedCountriesGeoJson ?? '',
            );
          },
        ),
        BlocListener<MapInteractionCubit, MapInteractionState>(
          listenWhen: (prev, curr) => prev.selectedCuisine != curr.selectedCuisine,
          listener: (context, state) async {
            if (state.selectedCuisine == null) return;
            await showFDialog(
              context: context,
              builder: (_, style, animation) {
                return CountryMapDetailsDialog(
                  country: state.selectedCuisine!.countryName,
                  flagEmoji: state.selectedCuisine!.flagEmoji,
                  dishes: state.selectedDishes,
                );
              },
            );
            if (!context.mounted) return;
            context.read<MapInteractionCubit>().clearSelection();
          },
        ),
      ],
      child: BlocBuilder<MapDataCubit, MapDataState>(
        buildWhen: (prev, curr) => prev.status != curr.status,
        builder: (context, state) {
          if (state.status == MapDataStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.status == MapDataStatus.failure) {
            return const Center(child: Text('Failed to load map'));
          }
          final loc = state.initialLocation!;
          return MapWidget(
            cameraOptions: CameraOptions(
              center: Point(coordinates: Position(loc.longitude!, loc.latitude!)),
              zoom: 1.5,
            ),
            styleUri: context.isDarkTheme ? MapboxStyles.DARK : MapboxStyles.LIGHT,
            key: ValueKey(context.isDarkTheme),
            textureView: true,
            onMapCreated: (controller) {
              final mapController = MapOverviewMapController(controller);
              context.read<MapControllerCubit>().initialize(mapController);
              controller.setOnMapTapListener((listener) async {
                final country = await mapController.getCountryAtPoint(
                  listener.touchPosition,
                );
                if (country == null || !context.mounted) return;
                final dishes = context.read<MapDataCubit>().state.dishes;
                context.read<MapInteractionCubit>().onCountrySelected(country, dishes);
              });
            },
            onStyleLoadedListener: (data) {
              final mapData = context.read<MapDataCubit>().state;
              context.read<MapControllerCubit>().onStyleLoaded(
                mapData.countriesGeoJson ?? '',
                mapData.highlightedCountriesGeoJson ?? '',
              );
            },
          );
        },
      ),
    );
  }
}
