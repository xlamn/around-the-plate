part of 'trips_overview_cubit.dart';

enum TripsOverviewStatus { initial, loading, success, failure }

class TripsOverviewState extends Equatable {
  final TripsOverviewStatus status;
  final List<Trip> trips;

  const TripsOverviewState({
    this.status = TripsOverviewStatus.initial,
    this.trips = const [],
  });

  TripsOverviewState copyWith({
    TripsOverviewStatus Function()? status,
    List<Trip> Function()? trips,
  }) {
    return TripsOverviewState(
      status: status != null ? status() : this.status,
      trips: trips != null ? trips() : this.trips,
    );
  }

  @override
  List<Object> get props => [status, trips];
}
