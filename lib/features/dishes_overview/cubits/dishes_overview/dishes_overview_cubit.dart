import 'package:flutter_bloc/flutter_bloc.dart';

import 'dishes_overview_state.dart';

class DishesOverviewCubit extends Cubit<DishesOverviewState> {
  DishesOverviewCubit() : super(const DishesOverviewState());

  Future<void> loadDishes() async {
    try {
      emit(state.copyWith(status: () => DishesOverviewStatus.loading));

      // load dishes from database
      await Future.delayed(Duration(seconds: 1));

      emit(
        state.copyWith(
          status: () => DishesOverviewStatus.success,
          dishes: () => [],
        ),
      );
    } catch (e) {
      emit(state.copyWith(status: () => DishesOverviewStatus.failure));
    }
  }
}
