import 'dart:async';
import 'dart:convert';

import 'package:dishes_api/dishes_api.dart';
import 'package:dishes_repository/dishes_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../extensions/extensions.dart';

part 'map_data_state.dart';

class MapDataCubit extends Cubit<MapDataState> {
  static const _geoJsonPath = 'assets/countries/countries.geojson';
  final DishesRepository _dishesRepository;
  StreamSubscription<List<Dish>>? _dishesSubscription;

  MapDataCubit({
    required DishesRepository dishesRepository,
  }) : _dishesRepository = dishesRepository,
       super(MapDataState());

  Future<void> loadGeoJson() async {
    emit(state.copyWith(status: () => MapDataStatus.loading));

    _dishesSubscription?.cancel(); // avoid multiple subscriptions

    _dishesSubscription = _dishesRepository.getDishes().listen(
      (dishes) async {
        try {
          // Load base GeoJSON
          final geoJsonString = await rootBundle.loadString(_geoJsonPath);
          final geoJson = jsonDecode(geoJsonString);

          // Count dishes per cuisine
          final Map<DishCuisine, int> cuisineCounts = {};
          for (final dish in dishes) {
            final cuisine = dish.cuisine;
            if (cuisine != null) {
              cuisineCounts[cuisine] = (cuisineCounts[cuisine] ?? 0) + 1;
            }
          }

          // Map cuisine to countryName and generate intensity
          final Map<String, double> countryIntensity = {};
          for (final entry in cuisineCounts.entries) {
            final countryName = cuisineCountryMap[entry.key]?.countryName
                .toLowerCase();
            if (countryName != null) {
              final count = entry.value;
              final normalized = (count / 20).clamp(0.0, 1.0);
              countryIntensity[countryName] = normalized;
            }
          }

          // create list with hightlighted features
          final List<dynamic> highlightedFeatures = [];

          for (final f in geoJson['features']) {
            try {
              final props = f['properties'] as Map<String, dynamic>;
              final countryName = (props['ADMIN'] ?? props['name'] ?? '')
                  .toString()
                  .toLowerCase();

              if (countryIntensity.containsKey(countryName)) {
                final intensity = countryIntensity[countryName] ?? 0;
                props['highlighted_for_cuisine'] = true;
                props['intensity'] = intensity;

                final color = intensity.generateColorFromNumber(
                  startColor: Color(0xFFFFF7EA),
                  endColor: Color(0xFF4CAF50),
                );
                props['fillColor'] = color;
                highlightedFeatures.add(f);
              }
            } catch (_) {
              // skip invalid features
            }
          }

          final highlightedGeoJson = {
            "type": "FeatureCollection",
            "features": highlightedFeatures,
          };
          final highlightedCountriesGeoJsonString = jsonEncode(
            highlightedGeoJson,
          );

          emit(
            state.copyWith(
              status: () => MapDataStatus.success,
              countriesGeoJson: () => geoJsonString,
              highlightedCountriesGeoJson: () =>
                  highlightedCountriesGeoJsonString,
            ),
          );
        } catch (_) {
          emit(state.copyWith(status: () => MapDataStatus.failure));
        }
      },
      onError: (_) {
        emit(state.copyWith(status: () => MapDataStatus.failure));
      },
    );
  }

  @override
  Future<void> close() {
    _dishesSubscription?.cancel();
    return super.close();
  }
}
