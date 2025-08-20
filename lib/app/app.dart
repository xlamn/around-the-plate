import 'package:dishes_repository/dishes_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forui/forui.dart';

import '../home/view/home.dart';

class App extends StatelessWidget {
  const App({required this.createDishesRepository, super.key});

  final DishesRepository Function() createDishesRepository;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider<DishesRepository>(
      create: (_) => createDishesRepository(),
      dispose: (repository) => repository.dispose(),
      child: const AppView(),
    );
  }
}

class AppView extends StatelessWidget {
  const AppView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = FThemes.slate.light;

    return MaterialApp(
      // TODO: replace with your application's supported locales.
      supportedLocales: FLocalizations.supportedLocales,
      // TODO: add your application's localizations delegates.
      localizationsDelegates: const [...FLocalizations.localizationsDelegates],
      builder: (_, child) => FTheme(data: theme, child: child!),
      theme: theme.toApproximateMaterialTheme(),
      home: Home(),
    );
  }
}
