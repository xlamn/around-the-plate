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

  AchievementsCubit({required DishesRepository dishesRepository})
      : _dishesRepository = dishesRepository,
        super(const AchievementsState());

  void load() {
    emit(state.copyWith(status: () => AchievementsStatus.loading));
    _subscription?.cancel();
    _subscription = _dishesRepository.getDishes().listen(
      (dishes) {
        emit(
          state.copyWith(
            status: () => AchievementsStatus.success,
            achievements: () => evaluateAchievements(dishes),
          ),
        );
      },
      onError: (_) =>
          emit(state.copyWith(status: () => AchievementsStatus.failure)),
    );
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
