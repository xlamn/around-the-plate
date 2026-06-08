part of 'achievements_cubit.dart';

enum AchievementsStatus { initial, loading, success, failure }

class AchievementsState extends Equatable {
  final AchievementsStatus status;
  final List<Achievement> achievements;
  final List<Achievement> newlyUnlockedAchievements;

  const AchievementsState({
    this.status = AchievementsStatus.initial,
    this.achievements = const [],
    this.newlyUnlockedAchievements = const [],
  });

  AchievementsState copyWith({
    AchievementsStatus Function()? status,
    List<Achievement> Function()? achievements,
    List<Achievement> Function()? newlyUnlockedAchievements,
  }) {
    return AchievementsState(
      status: status != null ? status() : this.status,
      achievements: achievements != null ? achievements() : this.achievements,
      newlyUnlockedAchievements: newlyUnlockedAchievements != null
          ? newlyUnlockedAchievements()
          : this.newlyUnlockedAchievements,
    );
  }

  @override
  List<Object> get props => [status, achievements, newlyUnlockedAchievements];
}
