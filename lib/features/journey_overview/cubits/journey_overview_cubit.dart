import 'dart:async';

import 'package:dishes_repository/dishes_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/dish_stats.dart';

part 'journey_overview_state.dart';

class JourneyOverviewCubit extends Cubit<JourneyOverviewState> {
  final DishesRepository _dishesRepository;
  StreamSubscription<List<Dish>>? _subscription;

  JourneyOverviewCubit({required DishesRepository dishesRepository})
    : _dishesRepository = dishesRepository,
      super(const JourneyOverviewState());

  void load() {
    emit(state.copyWith(status: () => JourneyOverviewStatus.loading));

    _subscription?.cancel(); // avoid multiple subscriptions

    _subscription = _dishesRepository.getDishes().listen(
      (dishes) {
        emit(
          state.copyWith(
            status: () => JourneyOverviewStatus.success,
            stats: () => DishStats.fromDishes(dishes),
          ),
        );
      },
      onError: (_) => emit(state.copyWith(status: () => JourneyOverviewStatus.failure)),
    );
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
