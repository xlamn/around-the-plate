part of 'dishes_search_cubit.dart';

class DishesSearchState extends Equatable {
  final String query;
  final List<Dish> filteredDishes;

  const DishesSearchState({
    this.query = '',
    this.filteredDishes = const [],
  });

  @override
  List<Object> get props => [query, filteredDishes];
}
