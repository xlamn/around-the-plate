part of 'trip_detail_cubit.dart';

enum TripDetailStatus { initial, loading, success, failure, notFound }

class TripDetailState extends Equatable {
  final TripDetailStatus status;
  final Trip? trip;
  final List<Dish> dishes;

  const TripDetailState({
    this.status = .initial,
    this.trip,
    this.dishes = const [],
  });

  TripDetailState copyWith({
    TripDetailStatus Function()? status,
    Trip? Function()? trip,
    List<Dish> Function()? dishes,
  }) {
    return TripDetailState(
      status: status != null ? status() : this.status,
      trip: trip != null ? trip() : this.trip,
      dishes: dishes != null ? dishes() : this.dishes,
    );
  }

  @override
  List<Object?> get props => [status, trip, dishes];
}
