import 'package:around_the_plate/features/add_dish/cubits/add_dish/add_dish_cubit.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:dishes_repository/dishes_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockDishesRepository extends Mock implements DishesRepository {}

class FakeDish extends Fake implements Dish {}

void main() {
  late DishesRepository dishesRepository;
  late Dish dish;

  setUp(() {
    dishesRepository = MockDishesRepository();
    dish = Dish(
      name: 'Pizza',
      categoryValue: DishCategory.meal.index,
      imagePath: '',
      rating: 1.0,
    );
  });

  setUpAll(() {
    registerFallbackValue(FakeDish());
  });

  AddDishCubit buildCubit() {
    return AddDishCubit(dishesRepository: dishesRepository);
  }

  group('`$AddDishCubit`', () {
    test('initial state is AddDishState', () {
      expect(buildCubit().state, equals(AddDishState()));
    });

    blocTest<AddDishCubit, AddDishState>(
      'emits [loading, success] when addDish succeeds',
      setUp: () {
        when(
          () => dishesRepository.saveDish(any()),
        ).thenAnswer((_) async => Future.value());
      },
      build: buildCubit,
      act: (cubit) => cubit.addDish(dish),
      expect: () => [
        AddDishState(status: AddDishStatus.loading),
        AddDishState(status: AddDishStatus.success, dish: dish),
      ],
      verify: (_) {
        verify(() => dishesRepository.saveDish(dish)).called(1);
      },
    );

    blocTest<AddDishCubit, AddDishState>(
      'emits [loading, failure] when addDish throws an exception',
      setUp: () {
        when(
          () => dishesRepository.saveDish(any()),
        ).thenThrow(Exception('save failed'));
      },
      build: buildCubit,
      act: (cubit) => cubit.addDish(dish),
      expect: () => [
        AddDishState(status: AddDishStatus.loading),
        AddDishState(status: AddDishStatus.failure),
      ],
    );
  });
}
