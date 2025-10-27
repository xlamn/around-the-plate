import 'package:app_theme/app_theme.dart';
import 'package:dishes_api/dishes_api.dart';
import 'package:dishes_repository/dishes_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

import '../cubits/map_controller/map_controller_cubit.dart';
import '../cubits/map_data/map_data_cubit.dart';
import '../cubits/map_interaction/map_interaction_cubit.dart';
import '../helpers/map_overview_controller.dart';
import '../widgets/map_overview_country_details_dialog.dart';

class MapOverviewPage extends StatelessWidget {
  const MapOverviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => MapDataCubit(
            dishesRepository: context.read<DishesRepository>(),
          )..loadGeoJson(),
        ),
        BlocProvider(
          create: (_) => MapControllerCubit(),
        ),
        BlocProvider(
          create: (_) => MapInteractionCubit(),
        ),
      ],
      child: const MapOverviewView(),
    );
  }
}

class MapOverviewView extends StatelessWidget {
  const MapOverviewView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MultiBlocListener(
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
            listenWhen: (prev, curr) =>
                prev.selectedCuisine != curr.selectedCuisine,
            listener: (context, state) async {
              if (state.selectedCuisine == null) return;
              await showFDialog(
                context: context,
                builder: (_, style, animation) {
                  return MapOverviewCountryDetailsDialog(
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
              return const Center(child: Text("Failed to load map"));
            }
            return Column(
              children: [
                const FHeader(title: Text('Map')),
                Expanded(
                  child: MapWidget(
                    cameraOptions: CameraOptions(
                      center: Point(coordinates: Position(12.12247, 47.85637)),
                      zoom: 2.2,
                    ),
                    styleUri: context.isDarkTheme
                        ? MapboxStyles.DARK
                        : MapboxStyles.LIGHT,
                    key: ValueKey(context.isDarkTheme),
                    textureView: true,
                    onMapCreated: (controller) {
                      final mapController = MapOverviewMapController(
                        controller,
                      );
                      context.read<MapControllerCubit>().initialize(
                        mapController,
                      );

                      controller.setOnMapTapListener((listener) async {
                        final country = await mapController.getCountryAtPoint(
                          listener.touchPosition,
                        );
                        if (country == null || !context.mounted) return;

                        final dishes = context
                            .read<MapDataCubit>()
                            .state
                            .dishes;

                        context.read<MapInteractionCubit>().onCountrySelected(
                          country,
                          dishes,
                        );
                      });
                    },
                    onStyleLoadedListener: (data) {
                      context.read<MapControllerCubit>().updateMap(
                        state.countriesGeoJson ?? '',
                        state.highlightedCountriesGeoJson ?? '',
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
