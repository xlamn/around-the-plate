part of 'onboarding_cubit.dart';

enum OnboardingStep { introduction, camera, location, done }

class OnboardingState {
  final OnboardingStep step;
  const OnboardingState({this.step = OnboardingStep.introduction});
}
