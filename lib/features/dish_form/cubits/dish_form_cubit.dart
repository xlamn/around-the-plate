import 'package:dishes_repository/dishes_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'dish_form_state.dart';

class DishFormCubit extends Cubit<DishFormState> {
  final DishesRepository _dishesRepository;

  DishFormCubit({
    required DishesRepository dishesRepository,
  }) : _dishesRepository = dishesRepository,
       super(DishFormState());

  Future<void> addDish(Dish dish) async {
    try {
      emit(state.copyWith(status: DishFormStatus.loading));
      await _dishesRepository.saveDish(dish);
      emit(
        state.copyWith(status: DishFormStatus.success, dish: dish),
      );
    } catch (e) {
      emit(
        state.copyWith(status: DishFormStatus.failure),
      );
    }
  }
}
