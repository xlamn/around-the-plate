part of 'dish_form_location_search_cubit.dart';

final class DishFormLocationSearchState extends Equatable {
  const DishFormLocationSearchState({
    this.permissionGranted = false,
    this.currentLocation,
    this.results = const [],
  });

  final bool permissionGranted;
  final DishLocation? currentLocation;
  final List<DishLocation> results;

  DishFormLocationSearchState copyWith({
    bool? permissionGranted,
    DishLocation? currentLocation,
    List<DishLocation>? results,
  }) {
    return DishFormLocationSearchState(
      permissionGranted: permissionGranted ?? this.permissionGranted,
      currentLocation: currentLocation ?? this.currentLocation,
      results: results ?? this.results,
    );
  }

  @override
  List<Object?> get props => [permissionGranted, currentLocation, results];
}
