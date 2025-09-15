import 'package:flutter_bloc/flutter_bloc.dart';

import 'onboarding_state.dart';

class OnboardingCubit extends Cubit<OnboardingState> {
  OnboardingCubit() : super(const OnboardingState());

  void nextStep() {
    switch (state.step) {
      case OnboardingStep.introduction:
        emit(const OnboardingState(step: OnboardingStep.camera));
        break;
      case OnboardingStep.camera:
        emit(const OnboardingState(step: OnboardingStep.location));
        break;
      case OnboardingStep.location:
        emit(const OnboardingState(step: OnboardingStep.done));
        break;
      default:
        break;
    }
  }
}
