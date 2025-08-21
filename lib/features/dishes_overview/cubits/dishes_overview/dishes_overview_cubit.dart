import 'dart:async';
import 'package:dishes_repository/dishes_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dishes_overview_state.dart';

class DishesOverviewCubit extends Cubit<DishesOverviewState> {
  final DishesRepository _dishesRepository;
  StreamSubscription<List<Dish>>? _dishesSubscription;

  DishesOverviewCubit({
    required DishesRepository dishesRepository,
  }) : _dishesRepository = dishesRepository,
       super(DishesOverviewState());

  void loadDishes() {
    emit(state.copyWith(status: () => DishesOverviewStatus.loading));

    _dishesSubscription?.cancel(); // avoid multiple subscriptions

    _dishesSubscription = _dishesRepository.getDishes().listen(
      (dishes) {
        emit(
          state.copyWith(
            status: () => DishesOverviewStatus.success,
            dishes: () => dishes,
          ),
        );
      },
      onError: (_) {
        emit(state.copyWith(status: () => DishesOverviewStatus.failure));
      },
    );
  }

  @override
  Future<void> close() {
    _dishesSubscription?.cancel();
    return super.close();
  }
}
