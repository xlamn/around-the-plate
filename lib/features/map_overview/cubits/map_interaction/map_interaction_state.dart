part of 'map_interaction_cubit.dart';

class MapInteractionState extends Equatable {
  final String? selectedCountry;
  final List<Dish> selectedDishes;

  const MapInteractionState({
    this.selectedCountry,
    this.selectedDishes = const [],
  });

  bool get hasSelection => selectedCountry != null;

  MapInteractionState copyWith({
    String? selectedCountry,
    List<Dish>? selectedDishes,
  }) {
    return MapInteractionState(
      selectedCountry: selectedCountry ?? this.selectedCountry,
      selectedDishes: selectedDishes ?? this.selectedDishes,
    );
  }

  @override
  List<Object?> get props => [selectedCountry, selectedDishes];
}
