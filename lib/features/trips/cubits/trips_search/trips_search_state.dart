part of 'trips_search_cubit.dart';

class TripsSearchState extends Equatable {
  final String query;
  final List<Trip> filteredTrips;

  const TripsSearchState({
    this.query = '',
    this.filteredTrips = const [],
  });

  @override
  List<Object> get props => [query, filteredTrips];
}
