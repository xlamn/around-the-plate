import 'package:around_the_plate/features/onboarding/cubit/onboarding_cubit.dart';
import 'package:around_the_plate/features/onboarding/views/camera/cubit/onboarding_camera_cubit.dart';
import 'package:around_the_plate/features/onboarding/views/camera/view/onboarding_camera_page.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forui/forui.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../../helpers/helpers.dart';

class MockOnboardingCubit extends MockBloc<OnboardingCubit, OnboardingState>
    implements OnboardingCubit {}

class MockOnboardingCameraCubit
    extends MockBloc<OnboardingCameraCubit, OnboardingCameraState>
    implements OnboardingCameraCubit {}

void main() {
  late OnboardingCubit onboardingCubit;
  late OnboardingCameraCubit onboardingCameraCubit;

  setUp(() {
    onboardingCubit = MockOnboardingCubit();
    onboardingCameraCubit = MockOnboardingCameraCubit();
    when(
      () => onboardingCameraCubit.state,
    ).thenReturn(const OnboardingCameraState());
    when(
      () => onboardingCubit.state,
    ).thenReturn(const OnboardingState());
    when(
      () => onboardingCameraCubit.requestCameraPermission(),
    ).thenAnswer((_) async => Future.value());
  });

  Widget buildSubject(Widget child) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: onboardingCubit),
        BlocProvider.value(value: onboardingCameraCubit),
      ],
      child: OnboardingCameraView(),
    );
  }

  group('`$OnboardingCameraPage`', () {
    testWidgets('renders $OnboardingCameraView', (tester) async {
      await tester.pumpApp(buildSubject(const OnboardingCameraPage()));

      expect(find.byType(OnboardingCameraView), findsOneWidget);
    });
  });

  group('`$OnboardingCameraView`', () {
    testWidgets('initially renders correctly', (tester) async {
      await tester.pumpApp(buildSubject(const OnboardingCameraView()));

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
      await tester.pumpApp(buildSubject(const OnboardingCameraView()));

      await tester.tap(find.byType(FButton));
      await tester.pump(Duration(seconds: 1));

      verify(() => onboardingCameraCubit.requestCameraPermission()).called(1);
    });

    testWidgets('listener calls OnboardingCubit.nextStep()', (tester) async {
      whenListen(
        onboardingCameraCubit,
        Stream.fromIterable([
          OnboardingCameraState(status: CameraPermissionStatus.granted),
        ]),
        initialState: OnboardingCameraState(),
      );
      await tester.pumpApp(buildSubject(const OnboardingCameraView()));
      await tester.pump(Duration(seconds: 1));

      verify(() => onboardingCubit.nextStep()).called(1);
    });
  });
}
