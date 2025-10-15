import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

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
}
