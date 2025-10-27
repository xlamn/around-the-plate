part of 'app_startup_cubit.dart';

enum AppStartupStatus { loading, loaded }

class AppStartupState {
  final AppStartupStatus status;
  final bool completed;

  const AppStartupState({
    required this.status,
    required this.completed,
  });

  factory AppStartupState.loading() =>
      const AppStartupState(status: AppStartupStatus.loading, completed: false);

  factory AppStartupState.loaded(bool completed) =>
      AppStartupState(status: AppStartupStatus.loaded, completed: completed);
}
