import 'package:around_the_plate/features/add_dish/widgets/add_dish_save_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forui/forui.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/helpers.dart';

class MockFunction extends Mock {
  Future<void> onPressed();
}

void main() {
  late MockFunction functions;

  setUp(() {
    functions = MockFunction();
    when(() => functions.onPressed()).thenAnswer((_) => Future.value());
  });

  Widget buildSubject() {
    return AddDishSaveButton(
      onPressed: functions.onPressed,
    );
  }

  group('`$AddDishSaveButton`', () {
    testWidgets('renders correctly', (tester) async {
      await tester.pumpApp(buildSubject());

      expect(find.byType(FButton), findsOneWidget);
      expect(find.text('Add Dish'), findsOneWidget);
    });

    testWidgets('calls correct function when pressed', (
      tester,
    ) async {
      await tester.pumpApp(buildSubject());

      await tester.tap(find.byType(AddDishSaveButton));
      await tester.pump(Duration(seconds: 1));

      verify(() => functions.onPressed()).called(1);
    });
  });
}
