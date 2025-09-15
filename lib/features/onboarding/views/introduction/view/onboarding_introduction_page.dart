import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../cubit/onboarding_cubit.dart';

class OnboardingIntroductionPage extends StatelessWidget {
  const OnboardingIntroductionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Welcome")),
      body: Center(
        child: ElevatedButton(
          onPressed: () => context.read<OnboardingCubit>().nextStep(),
          child: const Text("Start Onboarding"),
        ),
      ),
    );
  }
}
