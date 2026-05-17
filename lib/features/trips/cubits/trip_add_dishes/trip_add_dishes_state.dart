part of 'trip_add_dishes_cubit.dart';

enum TripAddDishesStatus { initial, loading, success, failure, saving, saved }

class TripAddDishesState extends Equatable {
  final TripAddDishesStatus status;
  final List<Dish> dishes;
  final Set<int> selectedDishIds;

  const TripAddDishesState({
    this.status = TripAddDishesStatus.initial,
    this.dishes = const [],
    this.selectedDishIds = const {},
  });

  bool get isSaving => status == TripAddDishesStatus.saving;

  TripAddDishesState copyWith({
    TripAddDishesStatus Function()? status,
    List<Dish> Function()? dishes,
    Set<int> Function()? selectedDishIds,
  }) {
    return TripAddDishesState(
      status: status != null ? status() : this.status,
      dishes: dishes != null ? dishes() : this.dishes,
      selectedDishIds: selectedDishIds != null ? selectedDishIds() : this.selectedDishIds,
    );
  }

  @override
  List<Object> get props => [status, dishes, selectedDishIds];
}
