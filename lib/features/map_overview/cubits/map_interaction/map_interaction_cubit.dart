import 'package:bloc/bloc.dart';
import 'package:dishes_api/dishes_api.dart';
import 'package:equatable/equatable.dart';

part 'map_interaction_state.dart';

class MapInteractionCubit extends Cubit<MapInteractionState> {
  MapInteractionCubit() : super(const MapInteractionState());

  void onCountrySelected(String country, List<Dish> allDishes) {
    final cuisine = getCuisineFromCountry(country);
    if (cuisine == null) {
      emit(state.copyWith(selectedCountry: country, selectedDishes: []));
      return;
    }

    final filteredDishes = allDishes
        .where((dish) => dish.cuisine == cuisine)
        .toList();

    emit(
      state.copyWith(
        selectedCountry: country,
        selectedDishes: filteredDishes,
      ),
    );
  }

  void clearSelection() {
    emit(const MapInteractionState());
  }
}
