import 'package:bloc/bloc.dart';
import 'package:dishes_api/dishes_api.dart';
import 'package:equatable/equatable.dart';

part 'map_interaction_state.dart';

class MapInteractionCubit extends Cubit<MapInteractionState> {
  MapInteractionCubit() : super(const MapInteractionState());

  void onCountrySelected(String country, List<Dish> allDishes) {
    final cuisine = getCuisineFromCountry(country);

    final filteredDishes = allDishes
        .where((dish) => dish.cuisine == cuisine)
        .toList();

    emit(
      state.copyWith(
        selectedCuisine: cuisine,
        selectedDishes: filteredDishes,
      ),
    );
  }

  void clearSelection() {
    emit(const MapInteractionState());
  }
}
