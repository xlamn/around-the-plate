part of 'map_overview_cubit.dart';

enum MapOverviewStatus { initial, loading, success, failure }

class MapOverviewState {
  final MapOverviewStatus status;
  final String? countriesGeoJson;
  final String? highlightedCountriesGeoJson;

  const MapOverviewState({
    this.status = MapOverviewStatus.initial,
    this.countriesGeoJson,
    this.highlightedCountriesGeoJson,
  });

  MapOverviewState copyWith({
    MapOverviewStatus Function()? status,
    String? Function()? countriesGeoJson,
    String? Function()? highlightedCountriesGeoJson,
  }) {
    return MapOverviewState(
      status: status != null ? status() : this.status,
      countriesGeoJson: countriesGeoJson != null
          ? countriesGeoJson()
          : this.countriesGeoJson,
      highlightedCountriesGeoJson: highlightedCountriesGeoJson != null
          ? highlightedCountriesGeoJson()
          : this.highlightedCountriesGeoJson,
    );
  }
}
