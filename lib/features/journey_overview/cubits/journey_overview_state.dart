part of 'journey_overview_cubit.dart';

enum JourneyOverviewStatus { initial, loading, success, failure }

class JourneyOverviewState extends Equatable {
  final JourneyOverviewStatus status;
  final DishStats stats;

  const JourneyOverviewState({
    this.status = JourneyOverviewStatus.initial,
    this.stats = DishStats.empty,
  });

  JourneyOverviewState copyWith({
    JourneyOverviewStatus Function()? status,
    DishStats Function()? stats,
  }) {
    return JourneyOverviewState(
      status: status != null ? status() : this.status,
      stats: stats != null ? stats() : this.stats,
    );
  }

  @override
  List<Object> get props => [status, stats];
}
