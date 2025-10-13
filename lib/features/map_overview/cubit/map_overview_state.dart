part of 'map_overview_cubit.dart';

enum MapOverviewStatus { initial, loading, success, failure }

class MapOverviewState {
  final MapOverviewStatus status;
  final String? allCountriesGeoJson;
  final String? highlightedCountriesGeoJson;

  const MapOverviewState({
    this.status = MapOverviewStatus.initial,
    this.allCountriesGeoJson,
    this.highlightedCountriesGeoJson,
  });

  MapOverviewState copyWith({
    MapOverviewStatus Function()? status,
    String? Function()? allCountriesGeoJson,
    String? Function()? highlightedCountriesGeoJson,
  }) {
    return MapOverviewState(
      status: status != null ? status() : this.status,
      allCountriesGeoJson: allCountriesGeoJson != null
          ? allCountriesGeoJson()
          : this.allCountriesGeoJson,
      highlightedCountriesGeoJson: highlightedCountriesGeoJson != null
          ? highlightedCountriesGeoJson()
          : this.highlightedCountriesGeoJson,
    );
  }
}
