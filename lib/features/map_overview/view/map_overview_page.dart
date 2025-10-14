import 'package:dishes_repository/dishes_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forui/forui.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

import '../../../env/env.dart';
import '../cubit/map_overview_cubit.dart';

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
  static const _allCountriesSourceId = "countries-source";
  static const _highlightedSourceId = "countries-highlighted-source";
  static const _highlightedLayerId = "countries-highlighted-fill";
  static const _bordersLayerId = "countries-borders";

  MapboxMap? mapboxMap;

  @override
  void initState() {
    MapboxOptions.setAccessToken(Env.mapboxApiKey);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<MapOverviewCubit, MapOverviewState>(
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
                  onMapCreated: _onMapCreated,
                  onStyleLoadedListener: _onStyleLoadedCallback,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _onMapCreated(MapboxMap mapboxMap) => this.mapboxMap = mapboxMap;

  Future<void> _onStyleLoadedCallback(StyleLoadedEventData data) async {
    final state = context.read<MapOverviewCubit>().state;
    if (state.status == MapOverviewStatus.success) {
      await _addLayers(state);
    }
  }

  Future<void> _addLayers(MapOverviewState state) async {
    if (mapboxMap == null) return;
    final style = mapboxMap!.style;

    await style.addSource(
      GeoJsonSource(
        id: _highlightedSourceId,
        data: state.highlightedCountriesGeoJson!,
      ),
    );

    await style.addLayer(
      FillLayer(
        id: _highlightedLayerId,
        sourceId: _highlightedSourceId,
        fillColorExpression: [
          'get',
          'fillColor',
        ],
        fillOpacity: 0.8,
      ),
    );

    await style.addLayer(
      LineLayer(
        id: _bordersLayerId,
        sourceId: _allCountriesSourceId,
        lineColor: Colors.black.withValues(alpha: 0.5).toARGB32(),
        lineWidth: 0.1,
      ),
    );
  }
}
