import 'package:around_the_plate/features/home/home.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  HomeCubit buildCubit() => HomeCubit();
  group('HomeCubit', () {
    group('constructor', () {
      test('works properly', () {
        expect(buildCubit, returnsNormally);
      });

      test('has correct initial state', () {
        expect(
          buildCubit().state,
          equals(0),
        );
      });
    });

    blocTest<HomeCubit, int>(
      'emits [1] when changeTab(1) is called',
      build: () => buildCubit(),
      act: (cubit) => cubit.changeTab(1),
      expect: () => [1],
    );

    blocTest<HomeCubit, int>(
      'emits [2] when changeTab(2) is called',
      build: () => buildCubit(),
      act: (cubit) => cubit.changeTab(2),
      expect: () => [2],
    );

    blocTest<HomeCubit, int>(
      'emits [1, 3] when changeTab(1) then changeTab(3) is called',
      build: () => buildCubit(),
      act: (cubit) {
        cubit.changeTab(1);
        cubit.changeTab(3);
      },
      expect: () => [1, 3],
    );
  });
}
