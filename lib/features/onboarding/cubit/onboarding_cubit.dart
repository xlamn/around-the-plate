import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'onboarding_state.dart';

class OnboardingCubit extends Cubit<OnboardingState> {
  OnboardingCubit() : super(const OnboardingState());

  Future<void> nextStep() async {
    switch (state.step) {
      case OnboardingStep.introduction:
        emit(const OnboardingState(step: OnboardingStep.camera));
        break;
      case OnboardingStep.camera:
        emit(const OnboardingState(step: OnboardingStep.location));
        break;
      case OnboardingStep.location:
        await _setOnboardingComplete();
        emit(const OnboardingState(step: OnboardingStep.done));
        break;
      default:
        break;
    }
  }

  checkPermissions() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final hasRequested = prefs.getBool('hasRequestedPermissions') ?? false;

    if (!hasRequested) {
      await nextStep();
    }
    emit(const OnboardingState(step: OnboardingStep.done));
  }

  Future<void> _setOnboardingComplete() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('hasRequestedPermissions', true);
  }
}
