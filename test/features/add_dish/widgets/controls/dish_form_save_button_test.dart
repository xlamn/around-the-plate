import 'package:app_theme/app_theme.dart';
import 'package:around_the_plate/features/dish_form/widgets/dish_form_save_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
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
    return DishFormSaveButton(
      onPressed: functions.onPressed,
    );
  }

  group('`$DishFormSaveButton`', () {
    testWidgets('renders correctly', (tester) async {
      await tester.pumpApp(buildSubject());

      expect(find.byType(FButton), findsOneWidget);
      expect(find.text('Add Dish'), findsOneWidget);
    });

    testWidgets('calls correct function when pressed', (
      tester,
    ) async {
      await tester.pumpApp(buildSubject());

      await tester.tap(find.byType(DishFormSaveButton));
      await tester.pump(const Duration(seconds: 1));

      verify(() => functions.onPressed()).called(1);
    });
  });
}
