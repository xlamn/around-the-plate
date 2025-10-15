import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

import '../../../../env/env.dart';
import '../../helpers/map_overview_controller.dart';
import '../../helpers/map_overview_ids.dart';
import 'map_controller_state.dart';

class MapControllerCubit extends Cubit<MapControllerState> {
  late final MapOverviewMapController _controller;

  MapControllerCubit() : super(const MapControllerState()) {
    MapboxOptions.setAccessToken(Env.mapboxApiKey);
  }

  /// Call this method first before interacting with the map.
  void initialize(MapboxMap controller) {
    _controller = MapOverviewMapController(controller);
    emit(state.copyWith(isMapLoaded: true));
  }

  /// Updates the map with new GeoJSON data.
  /// Does nothing if the map is not yet loaded.
  Future<void> updateMap(
    String countriesJson,
    String highlightedCountriesJson,
  ) async {
    if (!state.isMapLoaded) {
      return;
    }

    emit(state.copyWith(status: MapControllerStatus.loading));

    try {
      await _controller.setOrUpdateSource(
        MapOverviewIds.allCountriesSource,
        countriesJson,
      );

      await _controller.setOrUpdateSource(
        MapOverviewIds.highlightedSource,
        highlightedCountriesJson,
      );

      await _controller.setOrUpdateLayer(
        LineLayer(
          id: MapOverviewIds.bordersLayer,
          sourceId: MapOverviewIds.allCountriesSource,
          lineColor: Colors.black.withValues(alpha: 0.5).toARGB32(),
          lineWidth: 0.1,
        ),
      );

      await _controller.setOrUpdateLayer(
        FillLayer(
          id: MapOverviewIds.highlightedLayer,
          sourceId: MapOverviewIds.highlightedSource,
          fillColorExpression: ['get', 'fillColor'],
          fillOpacity: 0.8,
        ),
      );
      emit(state.copyWith(status: MapControllerStatus.success));
    } catch (_) {
      emit(state.copyWith(status: MapControllerStatus.failure));
    }
  }
}
