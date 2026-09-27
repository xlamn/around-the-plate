import 'package:app_theme/app_theme.dart';
import 'package:dishes_repository/dishes_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:trips_repository/trips_repository.dart';

import '../features/home/view/home.dart';
import '../features/onboarding/views/onboarding_flow.dart';
import 'cubits/app_startup_cubit.dart';

class App extends StatelessWidget {
  const App({
    required this.createDishesRepository,
    required this.createTripsRepository,
    super.key,
  });

  final DishesRepository Function() createDishesRepository;
  final TripsRepository Function() createTripsRepository;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<DishesRepository>(
          create: (_) => createDishesRepository(),
          dispose: (r) => r.dispose(),
        ),
        RepositoryProvider<TripsRepository>(
          create: (_) => createTripsRepository(),
          dispose: (r) => r.dispose(),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => ThemeModeCubit()),
          BlocProvider(create: (_) => AppStartupCubit()),
        ],
        child: const AppView(),
      ),
    );
  }
}

class AppView extends StatelessWidget {
  const AppView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.isDarkTheme ? plateDark : plateLight;

    return MaterialApp(
      supportedLocales: FLocalizations.supportedLocales,
      localizationsDelegates: const [
        ...FLocalizations.localizationsDelegates,
        ...GlobalMaterialLocalizations.delegates,
      ],
      builder: (_, child) => FTheme(data: theme, child: child!),
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme(
          brightness: theme.colors.brightness,
          primary: theme.colors.primary,
          onPrimary: theme.colors.primaryForeground,
          secondary: theme.colors.secondary,
          onSecondary: theme.colors.secondaryForeground,
          error: theme.colors.error,
          onError: theme.colors.errorForeground,
          surface: theme.colors.background,
          onSurface: theme.colors.foreground,
        ),
        actionIconTheme: ActionIconThemeData(
          backButtonIconBuilder: (context) => const Icon(
            FLucideIcons.arrowLeft,
          ),
        ),
      ),
      home: BlocBuilder<AppStartupCubit, AppStartupState>(
        builder: (context, state) {
          return !state.completed
              ? OnboardingFlow(
                  onFinished: context.read<AppStartupCubit>().completeOnboarding,
                )
              : const Home();
        },
      ),
    );
  }
}
