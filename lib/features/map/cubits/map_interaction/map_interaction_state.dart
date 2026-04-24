part of 'map_interaction_cubit.dart';

class MapInteractionState extends Equatable {
  final DishCuisine? selectedCuisine;
  final List<Dish> selectedDishes;

  const MapInteractionState({
    this.selectedCuisine,
    this.selectedDishes = const [],
  });

  bool get hasSelection => selectedCuisine != null;

  MapInteractionState copyWith({
    DishCuisine? selectedCuisine,
    List<Dish>? selectedDishes,
  }) {
    return MapInteractionState(
      selectedCuisine: selectedCuisine ?? this.selectedCuisine,
      selectedDishes: selectedDishes ?? this.selectedDishes,
    );
  }

  @override
  List<Object?> get props => [selectedCuisine, selectedDishes];
}
