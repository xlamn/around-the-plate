part of 'home_search_cubit.dart';

class HomeSearchState extends Equatable {
  final String query;
  final List<Dish> filteredDishes;
  final List<Trip> filteredTrips;

  const HomeSearchState({
    this.query = '',
    this.filteredDishes = const [],
    this.filteredTrips = const [],
  });

  @override
  List<Object> get props => [query, filteredDishes, filteredTrips];
}
