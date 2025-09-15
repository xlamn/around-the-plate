part of 'app_startup_cubit.dart';

class AppStartupState {
  final bool isOnboardingCompleted;

  const AppStartupState._(this.isOnboardingCompleted);

  factory AppStartupState.loading() => const AppStartupState._(false);

  factory AppStartupState.loaded(bool completed) =>
      AppStartupState._(completed);
}
