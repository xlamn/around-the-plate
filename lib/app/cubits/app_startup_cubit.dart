import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'app_startup_state.dart';

class AppStartupCubit extends Cubit<AppStartupState> {
  AppStartupCubit() : super(AppStartupState.loading()) {
    _loadOnboardingStatus();
  }

  Future<void> _loadOnboardingStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final completed = prefs.getBool('onboardingCompleted') ?? false;
    emit(AppStartupState.loaded(completed));
  }

  Future<void> completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboardingCompleted', true);
    emit(AppStartupState.loaded(true));
  }
}
