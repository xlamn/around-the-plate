part of 'map_overview_cubit.dart';

enum MapOverviewStatus { initial, loading, success, failure }

class MapOverviewState {
  final MapOverviewStatus status;
  final String? highlightedCountriesGeoJson;

  const MapOverviewState({
    this.status = MapOverviewStatus.initial,
    this.highlightedCountriesGeoJson,
  });

  MapOverviewState copyWith({
    MapOverviewStatus Function()? status,
    String? Function()? highlightedCountriesGeoJson,
  }) {
    return MapOverviewState(
      status: status != null ? status() : this.status,
      highlightedCountriesGeoJson: highlightedCountriesGeoJson != null
          ? highlightedCountriesGeoJson()
          : this.highlightedCountriesGeoJson,
    );
  }
}
