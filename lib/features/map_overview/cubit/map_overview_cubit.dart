import 'dart:async';
import 'dart:convert';

import 'package:dishes_api/dishes_api.dart';
import 'package:dishes_repository/dishes_repository.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'map_overview_state.dart';

class MapOverviewCubit extends Cubit<MapOverviewState> {
  final DishesRepository _dishesRepository;
  StreamSubscription<List<Dish>>? _dishesSubscription;

  MapOverviewCubit({
    required DishesRepository dishesRepository,
  }) : _dishesRepository = dishesRepository,
       super(MapOverviewState());

  static const _geoJsonPath = 'assets/countries/countries.geojson';

  Future<void> loadCountries() async {
    emit(state.copyWith(status: () => MapOverviewStatus.loading));

    _dishesSubscription?.cancel(); // avoid multiple subscriptions

    _dishesSubscription = _dishesRepository.getDishes().listen(
      (dishes) async {
        try {
          // Load base GeoJSON
          final geoJsonString = await rootBundle.loadString(_geoJsonPath);
          final geoJson = jsonDecode(geoJsonString);

          // Extract cuisines from dishes
          final representedCuisines = dishes
              .where((d) => d.cuisine != null)
              .map((d) => d.cuisine!)
              .toSet();

          // Map cuisines to country names
          final highlightedCountries = representedCuisines
              .map(
                (cuisine) =>
                    cuisineCountryMap[cuisine]?.countryName.toLowerCase(),
              )
              .whereType<String>()
              .toSet();

          // Filter GeoJSON features by highlightedNames
          final List<dynamic> highlightedFeatures = [];
          if (geoJson['features'] is List) {
            for (final f in geoJson['features']) {
              try {
                final props = f['properties'] as Map<String, dynamic>;
                final countryName = (props['ADMIN'] ?? props['name'] ?? '')
                    .toString()
                    .toLowerCase();
                if (highlightedCountries.contains(countryName)) {
                  props['highlighted_for_cuisine'] = true;
                  highlightedFeatures.add(f);
                }
              } catch (_) {
                // skip invalid features
              }
            }
          }

          // Build new highlighted GeoJSON
          final highlightedGeoJson = {
            "type": "FeatureCollection",
            "features": highlightedFeatures,
          };
          final highlightedCountriesGeoJsonString = jsonEncode(
            highlightedGeoJson,
          );

          emit(
            state.copyWith(
              status: () => MapOverviewStatus.success,
              allCountriesGeoJson: () => geoJsonString,
              highlightedCountriesGeoJson: () =>
                  highlightedCountriesGeoJsonString,
            ),
          );
        } catch (_) {
          emit(state.copyWith(status: () => MapOverviewStatus.failure));
        }
      },
      onError: (_) {
        emit(state.copyWith(status: () => MapOverviewStatus.failure));
      },
    );
  }

  @override
  Future<void> close() {
    _dishesSubscription?.cancel();
    return super.close();
  }
}
