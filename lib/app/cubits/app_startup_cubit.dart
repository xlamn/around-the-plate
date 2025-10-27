import 'package:hydrated_bloc/hydrated_bloc.dart';

part 'app_startup_state.dart';

class AppStartupCubit extends HydratedCubit<AppStartupState> {
  AppStartupCubit() : super(AppStartupState.loading());

  static const _onboardingCompletedKey = 'onboardingCompleted';

  void completeOnboarding() {
    emit(AppStartupState.loaded(true));
  }

  @override
  AppStartupState? fromJson(Map<String, dynamic> json) {
    try {
      final completed = json[_onboardingCompletedKey] as bool? ?? false;
      return AppStartupState.loaded(completed);
    } catch (_) {
      return AppStartupState.loading();
    }
  }

  @override
  Map<String, dynamic>? toJson(AppStartupState state) {
    return {_onboardingCompletedKey: state.completed};
  }
}
