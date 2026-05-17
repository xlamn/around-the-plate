import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trips_repository/trips_repository.dart';

part 'trip_form_state.dart';

class TripFormCubit extends Cubit<TripFormState> {
  final TripsRepository _tripsRepository;

  TripFormCubit({
    required TripsRepository tripsRepository,
  }) : _tripsRepository = tripsRepository,
       super(const TripFormState());

  Future<void> saveTrip(Trip trip) async {
    try {
      emit(state.copyWith(status: TripFormStatus.loading));
      await _tripsRepository.saveTrip(trip);
      emit(state.copyWith(status: TripFormStatus.success, trip: trip));
    } catch (_) {
      emit(state.copyWith(status: TripFormStatus.failure));
    }
  }

  Future<void> deleteTrip(Trip trip) async {
    emit(state.copyWith(status: TripFormStatus.loading));
    try {
      await _tripsRepository.deleteTrip(trip.id);
      emit(state.copyWith(status: TripFormStatus.deleted));
    } catch (_) {
      emit(state.copyWith(status: TripFormStatus.failure));
    }
  }
}
