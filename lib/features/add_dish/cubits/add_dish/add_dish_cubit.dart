import 'package:dishes_repository/dishes_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'add_dish_state.dart';

class AddDishCubit extends Cubit<AddDishState> {
  AddDishCubit() : super(AddDishState());

  Future<void> addDish(Dish dish) async {
    try {
      emit(state.copyWith(status: AddDishStatus.loading));

      // save dish in database
      await Future.delayed(Duration(seconds: 1));

      emit(state.copyWith(status: AddDishStatus.success, dish: dish));
    } catch (e) {
      emit(state.copyWith(status: AddDishStatus.failure));
    }
  }
}
