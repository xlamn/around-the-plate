import 'package:around_the_plate/models/dish.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'add_dish_state.dart';

class AddDishCubit extends Cubit<AddDishState> {
  AddDishCubit() : super(AddDishInitial());

  Future<void> addDish(Dish dish) async {
    try {
      emit(AddDishLoading());

      // save dish in database
      await Future.delayed(Duration(seconds: 1));

      emit(AddDishSuccess(dish: dish));
    } catch (e) {
      emit(AddDishError("Failed to add dish"));
    }
  }
}
