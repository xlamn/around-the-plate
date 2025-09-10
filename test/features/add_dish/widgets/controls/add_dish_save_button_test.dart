import 'package:around_the_plate/features/add_dish/cubits/add_dish/add_dish_cubit.dart';
import 'package:around_the_plate/features/add_dish/cubits/add_dish/add_dish_state.dart';
import 'package:around_the_plate/features/add_dish/widgets/add_dish_save_button.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:dishes_repository/dishes_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forui/forui.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/helpers.dart';

class MockAddDishCubit extends MockBloc<AddDishCubit, AddDishState>
    implements AddDishCubit {}

void main() {
  late AddDishCubit addDishCubit;
  late Dish dish;

  setUp(() {
    addDishCubit = MockAddDishCubit();
    dish = Dish(
      name: 'Test Dish',
      imagePath: '/path/to/image.jpg',
      rating: 4.5,
    );
    when(() => addDishCubit.addDish(dish)).thenAnswer((_) => Future.value());
  });

  Widget buildSubject() {
    return BlocProvider<AddDishCubit>.value(
      value: addDishCubit,
      child: AddDishSaveButton(
        getDish: () => dish,
      ),
    );
  }

  group('AddDishSaveButton', () {
    testWidgets('renders correctly', (tester) async {
      await tester.pumpApp(buildSubject());

      expect(find.byType(FButton), findsOneWidget);
      expect(find.text('Add Dish'), findsOneWidget);
    });

    testWidgets('calls cubit.addDish when pressed', (
      tester,
    ) async {
      await tester.pumpApp(buildSubject());

      await tester.tap(find.byType(AddDishSaveButton));
      await tester.pump(Duration(seconds: 1));

      verify(() => addDishCubit.addDish(dish)).called(1);
    });
  });
}
