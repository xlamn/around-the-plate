import 'package:around_the_plate/features/onboarding/cubit/onboarding_cubit.dart';
import 'package:around_the_plate/features/onboarding/views/location/cubit/onboarding_location_cubit.dart';
import 'package:around_the_plate/features/onboarding/views/location/view/onboarding_location_page.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forui/forui.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../../helpers/helpers.dart';

class MockOnboardingCubit extends MockBloc<OnboardingCubit, OnboardingState>
    implements OnboardingCubit {}

class MockOnboardingLocationCubit
    extends MockBloc<OnboardingLocationCubit, OnboardingLocationState>
    implements OnboardingLocationCubit {}

void main() {
  late OnboardingCubit onboardingCubit;
  late OnboardingLocationCubit onboardingLocationCubit;

  setUp(() {
    onboardingCubit = MockOnboardingCubit();
    onboardingLocationCubit = MockOnboardingLocationCubit();
    when(
      () => onboardingLocationCubit.state,
    ).thenReturn(const OnboardingLocationState());
    when(
      () => onboardingCubit.state,
    ).thenReturn(const OnboardingState());
    when(
      () => onboardingLocationCubit.requestLocationPermission(),
    ).thenAnswer((_) async => Future.value());
  });

  Widget buildSubject(Widget child) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: onboardingCubit),
        BlocProvider.value(value: onboardingLocationCubit),
      ],
      child: OnboardingLocationView(),
    );
  }

  group('`$OnboardingLocationPage`', () {
    testWidgets('renders $OnboardingLocationView', (tester) async {
      await tester.pumpApp(buildSubject(const OnboardingLocationPage()));

      expect(find.byType(OnboardingLocationView), findsOneWidget);
    });
  });

  group('`$OnboardingLocationView`', () {
    testWidgets('initially renders correctly', (tester) async {
      await tester.pumpApp(buildSubject(const OnboardingLocationView()));

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
      await tester.pumpApp(buildSubject(const OnboardingLocationView()));

      await tester.tap(find.byType(FButton));
      await tester.pump(Duration(seconds: 1));

      verify(
        () => onboardingLocationCubit.requestLocationPermission(),
      ).called(1);
    });

    testWidgets('listener calls $OnboardingCubit.nextStep()', (tester) async {
      whenListen(
        onboardingLocationCubit,
        Stream.fromIterable([
          OnboardingLocationState(status: LocationPermissionStatus.granted),
        ]),
        initialState: OnboardingLocationState(),
      );
      await tester.pumpApp(buildSubject(const OnboardingLocationView()));
      await tester.pump(Duration(seconds: 1));

      verify(() => onboardingCubit.nextStep()).called(1);
    });
  });
}
