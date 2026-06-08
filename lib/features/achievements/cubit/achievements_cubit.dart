import 'dart:async';

import 'package:dishes_repository/dishes_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/achievement.dart';
import '../models/achievement_definitions.dart';

part 'achievements_state.dart';

class AchievementsCubit extends Cubit<AchievementsState> {
  final DishesRepository _dishesRepository;
  StreamSubscription<List<Dish>>? _subscription;
  int _isFirstLoad = 2; // quick-fix: getDishes gets called twice on app start

  AchievementsCubit({required DishesRepository dishesRepository})
    : _dishesRepository = dishesRepository,
      super(const AchievementsState()) {
    _load();
  }

  void _load() {
    emit(state.copyWith(status: () => AchievementsStatus.loading));
    _subscription?.cancel();
    _subscription = _dishesRepository.getDishes().listen(
      (dishes) {
        final updated = evaluateAchievements(dishes);
        final newlyUnlocked = _isFirstLoad != 0
            ? <Achievement>[]
            : updated
                  .where((a) => a.isUnlocked)
                  .where((a) => !state.achievements.any((p) => p.id == a.id && p.isUnlocked))
                  .toList();
        _isFirstLoad--;
        emit(
          state.copyWith(
            status: () => AchievementsStatus.success,
            achievements: () => updated,
            newlyUnlockedAchievements: () => newlyUnlocked,
          ),
        );
      },
      onError: (_) => emit(state.copyWith(status: () => AchievementsStatus.failure)),
    );
  }

  void clearNewlyUnlocked() {
    emit(state.copyWith(newlyUnlockedAchievements: () => []));
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
