import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/onboarding_cubit.dart';
import '../cubit/onboarding_state.dart';
import 'camera/view/onboarding_camera_page.dart';
import 'introduction/view/onboarding_introduction_page.dart';
import 'location/view/onboarding_location_page.dart';

class OnboardingFlow extends StatelessWidget {
  const OnboardingFlow({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => OnboardingCubit(),
      child: BlocBuilder<OnboardingCubit, OnboardingState>(
        builder: (context, state) {
          switch (state.step) {
            case OnboardingStep.introduction:
              return const OnboardingIntroductionPage();
            case OnboardingStep.camera:
              return const OnboardingCameraPage();
            case OnboardingStep.location:
              return const OnboardingLocationPage();
            case OnboardingStep.done:
              return const Scaffold(
                body: Center(child: Text("🎉 Onboarding complete!")),
              );
          }
        },
      ),
    );
  }
}
