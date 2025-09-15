import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../cubit/onboarding_cubit.dart';

class OnboardingIntroductionPage extends StatelessWidget {
  const OnboardingIntroductionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Welcome to Around The Plate")),
      body: Column(
        children: [
          Text('Before we get started, we need to set up a few permissions.'),
          Center(
            child: ElevatedButton(
              onPressed: () => context.read<OnboardingCubit>().nextStep(),
              child: const Text("Start"),
            ),
          ),
        ],
      ),
    );
  }
}
