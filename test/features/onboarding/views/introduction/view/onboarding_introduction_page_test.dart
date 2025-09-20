import 'package:around_the_plate/features/onboarding/cubit/onboarding_cubit.dart';
import 'package:around_the_plate/features/onboarding/views/introduction/view/onboarding_introduction_page.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forui/forui.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../../helpers/helpers.dart';

class MockOnboardingCubit extends MockBloc<OnboardingCubit, OnboardingState>
    implements OnboardingCubit {}

void main() {
  late OnboardingCubit onboardingCubit;

  setUp(() {
    onboardingCubit = MockOnboardingCubit();
  });

  Widget buildSubject() {
    return BlocProvider.value(
      value: onboardingCubit,
      child: OnboardingIntroductionPage(),
    );
  }

  group('`$OnboardingIntroductionPage`', () {
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

      verify(() => onboardingCubit.nextStep()).called(1);
    });
  });
}
