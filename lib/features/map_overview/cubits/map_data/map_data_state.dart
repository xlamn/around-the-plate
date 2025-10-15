part of 'map_data_cubit.dart';

enum MapDataStatus { initial, loading, success, failure }

class MapDataState extends Equatable {
  final MapDataStatus status;
  final String? countriesGeoJson;
  final String? highlightedCountriesGeoJson;

  const MapDataState({
    this.status = MapDataStatus.initial,
    this.countriesGeoJson,
    this.highlightedCountriesGeoJson,
  });

  MapDataState copyWith({
    MapDataStatus Function()? status,
    String? Function()? countriesGeoJson,
    String? Function()? highlightedCountriesGeoJson,
  }) {
    return MapDataState(
      status: status != null ? status() : this.status,
      countriesGeoJson: countriesGeoJson != null
          ? countriesGeoJson()
          : this.countriesGeoJson,
      highlightedCountriesGeoJson: highlightedCountriesGeoJson != null
          ? highlightedCountriesGeoJson()
          : this.highlightedCountriesGeoJson,
    );
  }

  @override
  List<Object?> get props => [status, highlightedCountriesGeoJson?.length];
}
