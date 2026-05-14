import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trips_repository/trips_repository.dart';

part 'trips_overview_state.dart';

class TripsOverviewCubit extends Cubit<TripsOverviewState> {
  final TripsRepository _tripsRepository;
  StreamSubscription<List<Trip>>? _tripsSubscription;

  TripsOverviewCubit({required TripsRepository tripsRepository})
    : _tripsRepository = tripsRepository,
      super(const TripsOverviewState());

  void loadTrips() {
    emit(state.copyWith(status: () => TripsOverviewStatus.loading));

    _tripsSubscription?.cancel();
    _tripsSubscription = _tripsRepository.getTrips().listen(
      (trips) => emit(
        state.copyWith(
          status: () => TripsOverviewStatus.success,
          trips: () => trips,
        ),
      ),
      onError: (_) => emit(state.copyWith(status: () => TripsOverviewStatus.failure)),
    );
  }

  @override
  Future<void> close() {
    _tripsSubscription?.cancel();
    return super.close();
  }
}
