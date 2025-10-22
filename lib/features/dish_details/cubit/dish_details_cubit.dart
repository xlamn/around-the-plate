import 'package:bloc/bloc.dart';
import 'package:dishes_repository/dishes_repository.dart';
import 'package:equatable/equatable.dart';

part 'dish_details_state.dart';

class DishDetailsCubit extends Cubit<DishDetailsState> {
  final DishesRepository _dishesRepository;

  DishDetailsCubit({
    required DishesRepository dishesRepository,
  }) : _dishesRepository = dishesRepository,
       super(const DishDetailsState.initial());

  Future<void> loadDish(int id) async {
    emit(state.copyWith(status: DishDetailsStatus.loading));
    try {
      final dish = await _dishesRepository.getDish(id);
      if (dish != null) {
        emit(state.copyWith(status: DishDetailsStatus.success, dish: dish));
      } else {
        emit(state.copyWith(status: DishDetailsStatus.notFound));
      }
    } catch (e) {
      emit(state.copyWith(status: DishDetailsStatus.failure));
    }
  }

  Future<void> refreshDish() async {
    if (state.dish != null) {
      await loadDish(state.dish!.id);
    }
  }
}
