import 'package:around_the_plate/features/onboarding/views/completion/view/onboarding_completion_page.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forui/forui.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../../helpers/helpers.dart';

class MockFunction extends Mock {
  Future<void> onFinished();
}

void main() {
  late MockFunction functions;

  setUp(() {
    functions = MockFunction();
    when(() => functions.onFinished()).thenAnswer((_) => Future.value());
  });

  Widget buildSubject() {
    return OnboardingCompletionPage(
      onFinished: functions.onFinished,
    );
  }

  group('`$OnboardingCompletionPage`', () {
    testWidgets('initially renders correctly', (tester) async {
      await tester.pumpApp(buildSubject());

      expect(
        find.byWidgetPredicate(
          (Widget widget) =>
              widget is Text && widget.style?.fontWeight == FontWeight.bold,
        ),
        findsOneWidget,
      );
      expect(find.byType(FButton), findsOneWidget);
    });

    testWidgets('calls correct function when pressed', (tester) async {
      await tester.pumpApp(buildSubject());

      await tester.tap(find.byType(FButton));
      await tester.pump(Duration(seconds: 1));

      verify(() => functions.onFinished()).called(1);
    });
  });
}
