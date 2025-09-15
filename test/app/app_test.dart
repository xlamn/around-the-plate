import 'package:around_the_plate/app/app.dart';
import 'package:around_the_plate/features/home/view/home.dart';
import 'package:dishes_repository/dishes_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../helpers/pump_app.dart';

void main() {
  late DishesRepository dishesRepository;

  setUp(() {
    dishesRepository = MockDishesRepository();
    when(
      () => dishesRepository.getDishes(),
    ).thenAnswer((_) => const Stream.empty());
  });

  group('App', () {
    testWidgets('renders AppView', (tester) async {
      await tester.pumpWidget(
        App(createDishesRepository: () => dishesRepository),
      );

      expect(find.byType(AppView), findsOneWidget);
    });
  });

  group('AppView', () {
    testWidgets('renders MaterialApp', (tester) async {
      await tester.pumpWidget(
        RepositoryProvider.value(
          value: dishesRepository,
          child: const AppView(),
        ),
      );

      expect(find.byType(MaterialApp), findsOneWidget);
    });

    testWidgets('renders Home', (tester) async {
      await tester.pumpWidget(
        RepositoryProvider.value(
          value: dishesRepository,
          child: const AppView(),
        ),
      );

      expect(find.byType(Home), findsOneWidget);
    });
  });
}
