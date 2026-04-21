import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

import '../../../../env/env.dart';
import '../../helpers/map_overview_controller.dart';
import '../../helpers/map_overview_ids.dart';
import 'map_controller_state.dart';

class MapControllerCubit extends Cubit<MapControllerState> {
  late MapOverviewMapController _controller;
  bool _isStyleLoaded = false;

  MapControllerCubit() : super(const MapControllerState()) {
    MapboxOptions.setAccessToken(Env.mapboxApiKey);
  }

  void initialize(MapOverviewMapController controller) {
    _controller = controller;
    _isStyleLoaded = false;
    emit(state.copyWith(isMapLoaded: true));
  }

  Future<void> onStyleLoaded(
    String countriesJson,
    String highlightedCountriesJson,
  ) async {
    _isStyleLoaded = true;
    await updateMap(countriesJson, highlightedCountriesJson);
  }

  /// Updates the map with new GeoJSON data.
  /// Does nothing if the map or style is not yet loaded.
  Future<void> updateMap(
    String countriesJson,
    String highlightedCountriesJson,
  ) async {
    if (!state.isMapLoaded || !_isStyleLoaded) {
      return;
    }

    emit(state.copyWith(status: MapControllerStatus.loading));

    try {
      await _controller.style.setProjection(
        StyleProjection(name: StyleProjectionName.mercator),
      );

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
