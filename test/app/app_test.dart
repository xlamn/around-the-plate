import 'package:around_the_plate/app/app.dart';
import 'package:around_the_plate/app/cubits/app_startup_cubit.dart';
import 'package:around_the_plate/features/home/view/home.dart';
import 'package:around_the_plate/features/onboarding/views/onboarding_flow.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:dishes_repository/dishes_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../helpers/pump_app.dart';

class MockAppStartupCubit extends MockBloc<AppStartupCubit, AppStartupState>
    implements AppStartupCubit {}

void main() {
  late DishesRepository dishesRepository;
  late AppStartupCubit appStartupCubit;

  setUp(() {
    appStartupCubit = MockAppStartupCubit();
    when(() => appStartupCubit.state).thenReturn(AppStartupState.loading());
    dishesRepository = MockDishesRepository();
    when(
      () => dishesRepository.getDishes(),
    ).thenAnswer((_) => const Stream.empty());
  });

  group('`$App`', () {
    testWidgets('renders AppView', (tester) async {
      when(
        () => appStartupCubit.state,
      ).thenReturn(AppStartupState.loaded(true));

      await tester.pumpWidget(
        App(createDishesRepository: () => dishesRepository),
      );

      expect(find.byType(BlocProvider<AppStartupCubit>), findsOneWidget);
      expect(find.byType(AppView), findsOneWidget);
    });
  });

  group('`$AppView`', () {
    testWidgets('renders $OnboardingFlow when onboarding not completed', (
      tester,
    ) async {
      await tester.pumpApp(
        dishesRepository: dishesRepository,
        BlocProvider.value(
          value: appStartupCubit,
          child: const AppView(),
        ),
      );

      expect(find.byType(OnboardingFlow), findsOneWidget);
    });

    testWidgets('renders $Home when onboarding completed', (tester) async {
      when(
        () => appStartupCubit.state,
      ).thenReturn(AppStartupState.loaded(true));

      await tester.pumpApp(
        dishesRepository: dishesRepository,
        BlocProvider.value(
          value: appStartupCubit,
          child: const AppView(),
        ),
      );

      expect(find.byType(Home), findsOneWidget);
    });
  });
}
