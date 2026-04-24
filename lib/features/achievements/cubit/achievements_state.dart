part of 'achievements_cubit.dart';

enum AchievementsStatus { initial, loading, success, failure }

class AchievementsState extends Equatable {
  final AchievementsStatus status;
  final List<Achievement> achievements;

  const AchievementsState({
    this.status = AchievementsStatus.initial,
    this.achievements = const [],
  });

  AchievementsState copyWith({
    AchievementsStatus Function()? status,
    List<Achievement> Function()? achievements,
  }) {
    return AchievementsState(
      status: status != null ? status() : this.status,
      achievements: achievements != null ? achievements() : this.achievements,
    );
  }

  @override
  List<Object> get props => [status, achievements];
}
