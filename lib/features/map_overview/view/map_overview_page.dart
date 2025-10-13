import 'dart:convert';

import 'package:dishes_api/dishes_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:forui/forui.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

import '../../../env/env.dart';

class MapOverviewPage extends StatefulWidget {
  const MapOverviewPage({super.key});

  @override
  State<MapOverviewPage> createState() => _MapOverviewPageState();
}

class _MapOverviewPageState extends State<MapOverviewPage> {
  MapboxMap? mapboxMap;

  static const _allCountriesSourceId = "countries-source";
  static const _highlightedSourceId = "countries-highlighted-source";
  static const _highlightedLayerId = "countries-highlighted-fill";
  static const _bordersLayerId = "countries-borders";

  @override
  void initState() {
    MapboxOptions.setAccessToken(Env.mapboxApiKey);
    super.initState();
  }

  void _onMapCreated(MapboxMap mapboxMap) {
    this.mapboxMap = mapboxMap;
  }

  Future<void> _onStyleLoadedCallback(StyleLoadedEventData data) async {
    await _addCountryHighlightLayer();
  }

  Future<void> _addCountryHighlightLayer() async {
    if (mapboxMap == null) return;
    final style = mapboxMap!.style;

    // 1) Load the base GeoJSON
    final geoJsonString = await rootBundle.loadString(
      'assets/countries/countries.geojson',
    );
    final Map<String, dynamic> geoJson = jsonDecode(geoJsonString);

    await style.addSource(
      GeoJsonSource(
        id: _allCountriesSourceId,
        data: geoJsonString,
      ),
    );

    // 2) Build a set of lower-cased names to highlight
    final highlightedNames = cuisineCountryMap.values
        .map((m) => m.countryName.toLowerCase())
        .toSet();

    // 3) Build a list of highlighted features
    final List<dynamic> highlightedFeatures = [];
    if (geoJson['features'] is List) {
      for (final f in geoJson['features']) {
        try {
          final props = f['properties'] as Map<String, dynamic>;
          final countryName = (props['ADMIN'] ?? props['name'] ?? '')
              .toString()
              .toLowerCase();
          if (highlightedNames.contains(countryName)) {
            // Optionally add a property so you can read it later on taps
            props['highlighted_for_cuisine'] = true;
            highlightedFeatures.add(f);
          }
        } catch (_) {
          // ignore malformed feature
        }
      }
    }

    // 4) Create a GeoJSON object for highlighted countries only
    final Map<String, dynamic> highlightedGeoJson = {
      "type": "FeatureCollection",
      "features": highlightedFeatures,
    };

    final highlightedGeoJsonString = jsonEncode(highlightedGeoJson);

    // 5) Add the highlighted source (only the filtered features)
    await style.addSource(
      GeoJsonSource(
        id: _highlightedSourceId,
        data: highlightedGeoJsonString,
      ),
    );

    // 6) Add the FillLayer for highlighted countries
    await style.addLayer(
      FillLayer(
        id: _highlightedLayerId,
        sourceId: _highlightedSourceId,
        fillColor: Colors.orange.withValues(alpha: 0.6).toARGB32(),
        fillOutlineColor: Colors.white.withValues(alpha: 0.6).toARGB32(),
      ),
    );

    // 9) Add a border layer for all countries (optional)
    await style.addLayer(
      LineLayer(
        id: _bordersLayerId,
        sourceId: _allCountriesSourceId,
        lineColor: Colors.blue.withValues(alpha: 0.3).toARGB32(),
        lineWidth: 0.6,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const FHeader(title: Text('Map')),
          Expanded(
            child: MapWidget(
              cameraOptions: CameraOptions(
                center: Point(coordinates: Position(10, 20)),
                zoom: 2.0,
              ),
              styleUri: MapboxStyles.LIGHT,
              textureView: true,
              onMapCreated: _onMapCreated,
              onStyleLoadedListener: _onStyleLoadedCallback,
            ),
          ),
        ],
      ),
    );
  }
}
