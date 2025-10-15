import 'package:around_the_plate/features/map_overview/helper/map_overview_ids.dart';
import 'package:dishes_repository/dishes_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forui/forui.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

import '../../../env/env.dart';
import '../cubit/map_overview_cubit.dart';
import '../helper/map_overview_controller.dart';

class MapOverviewPage extends StatelessWidget {
  const MapOverviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => MapOverviewCubit(
        dishesRepository: context.read<DishesRepository>(),
      )..loadGeoJson(),
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
  MapOverviewMapController? _mapController;

  @override
  void initState() {
    MapboxOptions.setAccessToken(Env.mapboxApiKey);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<MapOverviewCubit, MapOverviewState>(
        listenWhen: (_, _) => _mapController != null,
        listener: (context, state) async {
          await _updateSources(state);
          await _updateLayers(state);
        },
        buildWhen: (prev, curr) => prev.status != curr.status,
        builder: (context, state) {
          if (state.status == MapOverviewStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.status == MapOverviewStatus.failure) {
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
                  onMapCreated: (c) =>
                      _mapController = MapOverviewMapController(c),
                  onStyleLoadedListener: _updateStyle,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _updateStyle(StyleLoadedEventData data) async {
    final state = context.read<MapOverviewCubit>().state;
    if (state.status == MapOverviewStatus.success) {
      await _updateSources(state);
      await _updateLayers(state);
    }
  }

  Future<void> _updateSources(MapOverviewState state) async {
    await _mapController?.setOrUpdateSource(
      MapOverviewIds.allCountriesSource,
      state.countriesGeoJson!,
    );
    await _mapController?.setOrUpdateSource(
      MapOverviewIds.highlightedSource,
      state.highlightedCountriesGeoJson!,
    );
  }

  Future<void> _updateLayers(MapOverviewState state) async {
    await _mapController?.setOrUpdateLayer(
      LineLayer(
        id: MapOverviewIds.bordersLayer,
        sourceId: MapOverviewIds.allCountriesSource,
        lineColor: Colors.black.withValues(alpha: 0.5).toARGB32(),
        lineWidth: 0.1,
      ),
    );
    await _mapController?.setOrUpdateLayer(
      FillLayer(
        id: MapOverviewIds.highlightedLayer,
        sourceId: MapOverviewIds.highlightedSource,
        fillColorExpression: [
          'get',
          'fillColor',
        ],
        fillOpacity: 0.8,
      ),
    );
  }
}
