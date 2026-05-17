import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trips_api/trips_api.dart';

part 'trips_search_state.dart';

class TripsSearchCubit extends Cubit<TripsSearchState> {
  final List<Trip> _allTrips;

  TripsSearchCubit(List<Trip> trips)
      : _allTrips = List.of(trips),
        super(TripsSearchState(filteredTrips: trips));

  void search(String query) {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) {
      emit(TripsSearchState(query: query, filteredTrips: _allTrips));
      return;
    }

    final filtered = _allTrips.where((trip) {
      if (trip.name.toLowerCase().contains(q)) return true;
      if (trip.description?.toLowerCase().contains(q) ?? false) return true;
      return false;
    }).toList();

    emit(TripsSearchState(query: query, filteredTrips: filtered));
  }
}
