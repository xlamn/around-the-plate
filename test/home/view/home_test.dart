import 'package:around_the_plate/features/dishes_overview/view/dishes_overview_page.dart';
import 'package:around_the_plate/features/map_overview/view/map_overview_page.dart';
import 'package:around_the_plate/features/settings_overview/view/settings_overview_page.dart';
import 'package:around_the_plate/features/home/home.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:dishes_repository/dishes_repository.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/helpers.dart';

class MockHomeCubit extends MockCubit<int> implements HomeCubit {}

void main() {
  late DishesRepository dishesRepository;

  group('`$Home`', () {
    setUp(() {
      dishesRepository = MockDishesRepository();
      when(dishesRepository.getDishes).thenAnswer((_) => const Stream.empty());
    });

    testWidgets('renders HomeView', (tester) async {
      await tester.pumpApp(
        const Home(),
        dishesRepository: dishesRepository,
      );

      expect(find.byType(HomeView), findsOneWidget);
    });
  });

  group('`$HomeView`', () {
    late HomeCubit cubit;

    setUp(() {
      cubit = MockHomeCubit();
      when(() => cubit.state).thenReturn(0);

      dishesRepository = MockDishesRepository();
      when(dishesRepository.getDishes).thenAnswer((_) => const Stream.empty());
    });

    Widget buildSubject() {
      return BlocProvider.value(
        value: cubit,
        child: HomeView(),
      );
    }

    testWidgets('renders `$DishesOverviewPage` when tab is set to 0', (
      tester,
    ) async {
      when(() => cubit.state).thenReturn(0);

      await tester.pumpApp(
        buildSubject(),
        dishesRepository: dishesRepository,
      );

      expect(find.byType(DishesOverviewPage), findsOneWidget);
      expect(find.byType(MapOverviewPage), findsNothing);
      expect(find.byType(SettingsOverviewPage), findsNothing);
    });

    testWidgets('renders `$MapOverviewPage` when tab is set to 1', (
      tester,
    ) async {
      when(() => cubit.state).thenReturn(1);

      await tester.pumpApp(
        buildSubject(),
        dishesRepository: dishesRepository,
      );

      expect(find.byType(DishesOverviewPage), findsNothing);
      expect(find.byType(MapOverviewPage), findsOneWidget);
      expect(find.byType(SettingsOverviewPage), findsNothing);
    });

    testWidgets('renders `$SettingsOverviewPage` when tab is set to 2', (
      tester,
    ) async {
      when(() => cubit.state).thenReturn(2);

      await tester.pumpApp(
        buildSubject(),
        dishesRepository: dishesRepository,
      );

      expect(find.byType(DishesOverviewPage), findsNothing);
      expect(find.byType(MapOverviewPage), findsNothing);
      expect(find.byType(SettingsOverviewPage), findsOneWidget);
    });
  });
}
