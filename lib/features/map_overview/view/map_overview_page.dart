import 'package:dishes_repository/dishes_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forui/forui.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

import '../../../env/env.dart';
import '../cubits/map_controller/map_controller_cubit.dart';
import '../cubits/map_data/map_data_cubit.dart';

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
      ],
      child: const MapOverviewView(),
    );
  }
}

class MapOverviewView extends StatefulWidget {
  const MapOverviewView({super.key});

  @override
  State<MapOverviewView> createState() => _MapOverviewViewState();
}

class _MapOverviewViewState extends State<MapOverviewView> {
  @override
  void initState() {
    MapboxOptions.setAccessToken(Env.mapboxApiKey);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<MapDataCubit, MapDataState>(
        listener: (context, state) {
          context.read<MapControllerCubit>().updateMap(
            state.countriesGeoJson ?? '',
            state.highlightedCountriesGeoJson ?? '',
          );
        },
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
                    styleUri: MapboxStyles.LIGHT,
                    textureView: true,
                    onMapCreated: (controller) => context
                        .read<MapControllerCubit>()
                        .initialize(controller),
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
