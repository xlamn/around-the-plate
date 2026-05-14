import 'package:app_theme/app_theme.dart';
import 'package:dishes_repository/dishes_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:trips_repository/trips_repository.dart';

class MockDishesRepository extends Mock implements DishesRepository {}

class MockTripsRepository extends Mock implements TripsRepository {}

extension PumpApp on WidgetTester {
  Future<void> pumpApp(
    Widget widget, {
    DishesRepository? dishesRepository,
  }) {
    return pumpWidget(
      RepositoryProvider.value(
        value: dishesRepository ?? MockDishesRepository(),
        child: BlocProvider(
          create: (_) => ThemeModeCubit(),
          child: MaterialApp(
            localizationsDelegates: const [
              ...FLocalizations.localizationsDelegates,
              GlobalMaterialLocalizations.delegate,
            ],
            supportedLocales: FLocalizations.supportedLocales,
            home: Scaffold(body: widget),
          ),
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
