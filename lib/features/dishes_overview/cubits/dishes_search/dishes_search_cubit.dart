import 'package:dishes_api/dishes_api.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'dishes_search_state.dart';

class DishesSearchCubit extends Cubit<DishesSearchState> {
  final List<Dish> _allDishes;

  DishesSearchCubit(List<Dish> dishes)
      : _allDishes = List.of(dishes),
        super(DishesSearchState(filteredDishes: dishes));

  void search(String query) {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) {
      emit(DishesSearchState(query: query, filteredDishes: _allDishes));
      return;
    }

    final filtered = _allDishes.where((dish) {
      if (dish.name.toLowerCase().contains(q)) return true;
      if (dish.category?.name.toLowerCase().contains(q) ?? false) return true;
      if (dish.cuisine?.name.toLowerCase().contains(q) ?? false) return true;
      if (dish.cuisine?.countryName.toLowerCase().contains(q) ?? false) return true;
      if (dish.date != null) {
        final d = dish.date!;
        if ('${d.day}.${d.month}.${d.year}'.contains(q)) return true;
      }
      if (dish.location?.placeName?.toLowerCase().contains(q) ?? false) return true;
      return false;
    }).toList();

    emit(DishesSearchState(query: query, filteredDishes: filtered));
  }
}
