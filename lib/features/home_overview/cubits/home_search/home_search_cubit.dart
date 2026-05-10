import 'package:dishes_api/dishes_api.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trips_repository/trips_repository.dart';

part 'home_search_state.dart';

class HomeSearchCubit extends Cubit<HomeSearchState> {
  final List<Dish> _allDishes;
  final List<Trip> _allTrips;

  HomeSearchCubit(List<Dish> dishes, List<Trip> trips)
    : _allDishes = List.of(dishes),
      _allTrips = List.of(trips),
      super(HomeSearchState(filteredDishes: dishes, filteredTrips: trips));

  void search(String query) {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) {
      emit(
        HomeSearchState(
          query: query,
          filteredDishes: _allDishes,
          filteredTrips: _allTrips,
        ),
      );
      return;
    }

    final filteredDishes = _allDishes.where((dish) {
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

    final filteredTrips = _allTrips.where((trip) => trip.name.toLowerCase().contains(q)).toList();

    emit(
      HomeSearchState(
        query: query,
        filteredDishes: filteredDishes,
        filteredTrips: filteredTrips,
      ),
    );
  }
}
