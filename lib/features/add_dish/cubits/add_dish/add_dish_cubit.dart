import 'package:dishes_repository/dishes_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'add_dish_state.dart';

class AddDishCubit extends Cubit<AddDishState> {
  final DishesRepository _dishesRepository;

  AddDishCubit({
    required DishesRepository dishesRepository,
  }) : _dishesRepository = dishesRepository,
       super(AddDishState());

  Future<void> addDish(Dish dish) async {
    try {
      emit(state.copyWith(status: AddDishStatus.loading));
      await _dishesRepository.saveDish(dish);
      emit(
        state.copyWith(status: AddDishStatus.success, dish: dish),
      );
    } catch (e) {
      emit(
        state.copyWith(status: AddDishStatus.failure),
      );
    }
  }
}
