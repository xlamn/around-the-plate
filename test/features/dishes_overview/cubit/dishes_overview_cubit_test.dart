import 'dart:async';

import 'package:around_the_plate/features/dishes_overview/cubits/dishes_overview_cubit.dart';
import 'package:around_the_plate/features/dishes_overview/cubits/dishes_overview_state.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:dishes_repository/dishes_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../helpers/helpers.dart';

void main() {
  late DishesRepository dishesRepository;
  late StreamController<List<Dish>> dishesController;

  setUp(() {
    dishesRepository = MockDishesRepository();
    dishesController = StreamController<List<Dish>>.broadcast();
    when(
      () => dishesRepository.getDishes(),
    ).thenAnswer((_) => dishesController.stream);
  });

  tearDown(() async {
    await dishesController.close();
  });

  DishesOverviewCubit buildCubit() => DishesOverviewCubit(
    dishesRepository: dishesRepository,
  );

  group('`$DishesOverviewCubit`', () {
    group('constructor', () {
      test('works properly', () {
        expect(buildCubit, returnsNormally);
      });

      test('has correct initial state', () {
        expect(
          DishesOverviewCubit(dishesRepository: dishesRepository).state,
          equals(
            const DishesOverviewState(),
          ),
        );
      });
    });

    blocTest<DishesOverviewCubit, DishesOverviewState>(
      'emits [loading, success] when loadDishes succeeds',
      build: () => DishesOverviewCubit(dishesRepository: dishesRepository),
      act: (cubit) {
        cubit.loadDishes();
        dishesController.add([
          Dish(
            name: 'Pizza',
            categoryValue: DishCategory.meal.index,
            imagePath: '',
            rating: 1.0,
          ),
        ]);
      },
      expect: () => [
        DishesOverviewState(status: DishesOverviewStatus.loading),
        isA<DishesOverviewState>()
            .having((s) => s.status, 'status', DishesOverviewStatus.success)
            .having((s) => s.dishes.length, 'dishes', 1),
      ],
    );

    blocTest<DishesOverviewCubit, DishesOverviewState>(
      'emits [loading, failure] when loadDishes fails',
      build: () => DishesOverviewCubit(dishesRepository: dishesRepository),
      act: (cubit) {
        cubit.loadDishes();
        dishesController.addError(Exception('oops'));
      },
      expect: () => [
        DishesOverviewState(status: DishesOverviewStatus.loading),
        isA<DishesOverviewState>()
            .having((s) => s.status, 'status', DishesOverviewStatus.failure)
            .having((s) => s.dishes.length, 'dishes', 0),
      ],
    );

    test('close cancels subscription', () async {
      final cubit = DishesOverviewCubit(dishesRepository: dishesRepository);
      cubit.loadDishes();
      await cubit.close();

      expect(dishesController.hasListener, false);
    });
  });
}
