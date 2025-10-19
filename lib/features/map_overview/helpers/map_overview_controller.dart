import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

import 'map_overview_ids.dart';

class MapOverviewMapController {
  final MapboxMap map;
  StyleManager get style => map.style;

  MapOverviewMapController(this.map);

  Future<void> setOrUpdateSource(String id, String data) async {
    try {
      final existing = await style.getSource(id) as GeoJsonSource?;
      if (existing != null) {
        await existing.updateGeoJSON(data);
      } else {
        await style.addSource(GeoJsonSource(id: id, data: data));
      }
    } catch (_) {
      await style.addSource(GeoJsonSource(id: id, data: data));
    }
  }

  Future<void> setOrUpdateLayer(Layer layer) async {
    try {
      final existing = await style.getLayer(layer.id);
      if (existing != null) {
        await style.updateLayer(layer);
      } else {
        await style.addLayer(layer);
      }
    } catch (_) {
      await style.addLayer(layer);
    }
  }

  /// Queries the map at the tapped point and returns the `countryName` property
  /// from your GeoJSON feature — or `null` if nothing was hit.
  Future<String?> getCountryAtPoint(ScreenCoordinate tapPoint) async {
    try {
      final features = await map.queryRenderedFeatures(
        RenderedQueryGeometry.fromScreenCoordinate(tapPoint),
        RenderedQueryOptions(
          layerIds: [MapOverviewIds.highlightedLayer],
          filter: null,
        ),
      );

      if (features.isEmpty) return null;

      final featureMap = features.first?.queriedFeature.feature;
      final props = featureMap?['properties'] as Map<dynamic, dynamic>?;
      if (props == null) return null;

      final name = props['name'];
      if (name is String) return name;

      return null;
    } catch (e) {
      return null;
    }
  }
}
