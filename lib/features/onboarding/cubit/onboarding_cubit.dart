import 'package:flutter_bloc/flutter_bloc.dart';

part 'onboarding_state.dart';

class OnboardingCubit extends Cubit<OnboardingState> {
  OnboardingCubit() : super(const OnboardingState());

  void nextStep() {
    int currentIndex = _stepsOrder.indexOf(state.step);
    if (currentIndex >= 0 && currentIndex < _stepsOrder.length - 1) {
      emit(OnboardingState(step: _stepsOrder[currentIndex + 1]));
    }
  }
}

final List<OnboardingStep> _stepsOrder = [
  OnboardingStep.introduction,
  OnboardingStep.camera,
  OnboardingStep.location,
  OnboardingStep.done,
];
