import 'package:equatable/equatable.dart';

import '../../../../models/dish.dart';

enum DishesOverviewStatus { initial, loading, success, failure }

class DishesOverviewState extends Equatable {
  final DishesOverviewStatus status;
  final List<Dish> dishes;

  const DishesOverviewState({
    this.status = DishesOverviewStatus.initial,
    this.dishes = const [],
  });

  DishesOverviewState copyWith({
    DishesOverviewStatus Function()? status,
    List<Dish> Function()? dishes,
  }) {
    return DishesOverviewState(
      status: status != null ? status() : this.status,
      dishes: dishes != null ? dishes() : this.dishes,
    );
  }

  @override
  List<Object> get props => [status, dishes];
}
