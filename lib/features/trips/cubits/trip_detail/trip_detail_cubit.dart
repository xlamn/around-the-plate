import 'package:dishes_repository/dishes_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trips_repository/trips_repository.dart';

part 'trip_detail_state.dart';

class TripDetailCubit extends Cubit<TripDetailState> {
  final TripsRepository _tripsRepository;
  final DishesRepository _dishesRepository;

  TripDetailCubit({
    required TripsRepository tripsRepository,
    required DishesRepository dishesRepository,
  }) : _tripsRepository = tripsRepository,
       _dishesRepository = dishesRepository,
       super(const TripDetailState());

  Future<void> loadTrip(int id) async {
    emit(state.copyWith(status: () => .loading));
    try {
      final trip = await _tripsRepository.getTrip(id);
      if (trip == null) {
        emit(state.copyWith(status: () => .notFound));
        return;
      }
      final dishes = await _loadDishes(trip.dishIds);
      emit(
        state.copyWith(
          status: () => .success,
          trip: () => trip,
          dishes: () => dishes,
        ),
      );
    } catch (_) {
      emit(state.copyWith(status: () => .failure));
    }
  }

  Future<void> addDish(int dishId) async {
    final trip = state.trip;
    if (trip == null || trip.dishIds.contains(dishId)) return;
    final updated = trip.copyWith(dishIds: [...trip.dishIds, dishId]);
    await _tripsRepository.saveTrip(updated);
    final dishes = await _loadDishes(updated.dishIds);
    emit(state.copyWith(trip: () => updated, dishes: () => dishes));
  }

  Future<void> removeDish(int dishId) async {
    final trip = state.trip;
    if (trip == null) return;
    final updated = trip.copyWith(dishIds: trip.dishIds.where((id) => id != dishId).toList());
    await _tripsRepository.saveTrip(updated);
    final dishes = await _loadDishes(updated.dishIds);
    emit(state.copyWith(trip: () => updated, dishes: () => dishes));
  }

  Future<void> deleteTrip() async {
    final trip = state.trip;
    if (trip == null) return;
    await _tripsRepository.deleteTrip(trip.id);
  }

  Future<List<Dish>> _loadDishes(List<int> ids) async {
    final results = await Future.wait(ids.map((id) => _dishesRepository.getDish(id)));
    return results.whereType<Dish>().toList();
  }
}
