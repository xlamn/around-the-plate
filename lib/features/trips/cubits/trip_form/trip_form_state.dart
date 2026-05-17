part of 'trip_form_cubit.dart';

enum TripFormStatus { initial, loading, success, deleted, failure }

final class TripFormState extends Equatable {
  const TripFormState({this.status = TripFormStatus.initial, this.trip});

  final TripFormStatus status;
  final Trip? trip;

  TripFormState copyWith({
    TripFormStatus? status,
    Trip? trip,
  }) {
    return TripFormState(
      status: status ?? this.status,
      trip: trip ?? this.trip,
    );
  }

  @override
  List<Object?> get props => [status, trip];
}
