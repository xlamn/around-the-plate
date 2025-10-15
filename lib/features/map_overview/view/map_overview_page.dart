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

  MapboxMap? controller;

  StyleManager? get _style => controller?.style;

  @override
  void initState() {
    MapboxOptions.setAccessToken(Env.mapboxApiKey);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<MapOverviewCubit, MapOverviewState>(
        listenWhen: (_, _) => controller != null,
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
                  onMapCreated: (c) => controller = c,
                  onStyleLoadedListener: _onStyleLoadedCallback,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _onStyleLoadedCallback(StyleLoadedEventData data) async {
    final state = context.read<MapOverviewCubit>().state;
    if (state.status == MapOverviewStatus.success) {
      await _updateSources(state);
      await _updateLayers(state);
    }
  }

  Future<void> _updateSources(MapOverviewState state) async {
    await _setOrUpdateSource(
      _allCountriesSourceId,
      state.countriesGeoJson!,
    );
    await _setOrUpdateSource(
      _highlightedSourceId,
      state.highlightedCountriesGeoJson!,
    );
  }

  Future<void> _setOrUpdateSource(String id, String data) async {
    final style = _style;
    if (style == null) return;
    try {
      final existing = await style.getSource(id) as GeoJsonSource?;
      if (existing != null) {
        await existing.updateGeoJSON(data);
      }
    } catch (_) {
      await style.addSource(GeoJsonSource(id: id, data: data));
    }
  }

  Future<void> _updateLayers(MapOverviewState state) async {
    await _setOrUpdateLayer(
      LineLayer(
        id: _bordersLayerId,
        sourceId: _allCountriesSourceId,
        lineColor: Colors.black.withValues(alpha: 0.5).toARGB32(),
        lineWidth: 0.1,
      ),
    );
    await _setOrUpdateLayer(
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
  }

  Future<void> _setOrUpdateLayer(Layer layer) async {
    final style = _style;
    if (style == null) return;

    try {
      final existing = await style.getLayer(layer.id);
      if (existing != null) {
        await style.updateLayer(
          layer,
        );
      }
    } catch (_) {
      await style.addLayer(
        layer,
      );
    }
  }
}
