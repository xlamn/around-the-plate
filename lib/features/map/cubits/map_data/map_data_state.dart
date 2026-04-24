part of 'map_data_cubit.dart';

enum MapDataStatus { initial, loading, success, failure }

class MapDataState extends Equatable {
  final MapDataStatus status;
  final List<Dish> dishes;
  final String? countriesGeoJson;
  final String? highlightedCountriesGeoJson;

  const MapDataState({
    this.status = MapDataStatus.initial,
    this.dishes = const [],
    this.countriesGeoJson,
    this.highlightedCountriesGeoJson,
  });

  MapDataState copyWith({
    MapDataStatus Function()? status,
    List<Dish> Function()? dishes,
    String? Function()? countriesGeoJson,
    String? Function()? highlightedCountriesGeoJson,
  }) {
    return MapDataState(
      status: status != null ? status() : this.status,
      dishes: dishes != null ? dishes() : this.dishes,
      countriesGeoJson: countriesGeoJson != null
          ? countriesGeoJson()
          : this.countriesGeoJson,
      highlightedCountriesGeoJson: highlightedCountriesGeoJson != null
          ? highlightedCountriesGeoJson()
          : this.highlightedCountriesGeoJson,
    );
  }

  @override
  List<Object?> get props => [
    status,
    dishes.length,
    highlightedCountriesGeoJson?.length,
  ];
}
