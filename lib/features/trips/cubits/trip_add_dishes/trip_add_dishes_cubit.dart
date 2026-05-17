import 'dart:async';

import 'package:dishes_repository/dishes_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trips_repository/trips_repository.dart';

part 'trip_add_dishes_state.dart';

class TripAddDishesCubit extends Cubit<TripAddDishesState> {
  final DishesRepository _dishesRepository;
  final TripsRepository _tripsRepository;
  StreamSubscription<List<Dish>>? _dishesSubscription;

  TripAddDishesCubit({
    required DishesRepository dishesRepository,
    required TripsRepository tripsRepository,
    required Set<int> initialSelectedIds,
  }) : _dishesRepository = dishesRepository,
       _tripsRepository = tripsRepository,
       super(TripAddDishesState(selectedDishIds: initialSelectedIds));

  void loadDishes() {
    emit(state.copyWith(status: () => TripAddDishesStatus.loading));
    _dishesSubscription?.cancel();
    _dishesSubscription = _dishesRepository.getDishes().listen(
      (dishes) => emit(state.copyWith(
        status: () => TripAddDishesStatus.success,
        dishes: () => dishes,
      )),
      onError: (_) => emit(state.copyWith(status: () => TripAddDishesStatus.failure)),
    );
  }

  void toggleDish(int dishId) {
    final ids = Set<int>.from(state.selectedDishIds);
    if (ids.contains(dishId)) {
      ids.remove(dishId);
    } else {
      ids.add(dishId);
    }
    emit(state.copyWith(selectedDishIds: () => ids));
  }

  Future<void> saveDishes(Trip trip) async {
    emit(state.copyWith(status: () => TripAddDishesStatus.saving));
    try {
      final updated = trip.copyWith(dishIds: state.selectedDishIds.toList());
      await _tripsRepository.saveTrip(updated);
      emit(state.copyWith(status: () => TripAddDishesStatus.saved));
    } catch (_) {
      emit(state.copyWith(status: () => TripAddDishesStatus.failure));
    }
  }

  @override
  Future<void> close() {
    _dishesSubscription?.cancel();
    return super.close();
  }
}
