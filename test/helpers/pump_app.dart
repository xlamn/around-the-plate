import 'package:dishes_repository/dishes_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forui/forui.dart';
import 'package:mocktail/mocktail.dart';

class MockDishesRepository extends Mock implements DishesRepository {}

extension PumpApp on WidgetTester {
  Future<void> pumpApp(
    Widget widget, {
    DishesRepository? dishesRepository,
  }) {
    return pumpWidget(
      RepositoryProvider.value(
        value: dishesRepository ?? MockDishesRepository(),
        child: MaterialApp(
          localizationsDelegates: const [
            ...FLocalizations.localizationsDelegates,
            GlobalMaterialLocalizations.delegate,
          ],
          supportedLocales: FLocalizations.supportedLocales,
          home: Scaffold(body: widget),
        ),
      ),
    );
  }

  Future<void> pumpRoute(
    Route<dynamic> route, {
    DishesRepository? dishesRepository,
  }) {
    return pumpApp(
      Navigator(onGenerateRoute: (_) => route),
      dishesRepository: dishesRepository,
    );
  }
}
