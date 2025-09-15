import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../cubit/onboarding_cubit.dart';
import '../cubit/onboarding_location_cubit.dart';
import '../cubit/onboarding_location_state.dart';

class OnboardingLocationPage extends StatelessWidget {
  const OnboardingLocationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => OnboardingLocationCubit(),
      child: BlocConsumer<OnboardingLocationCubit, OnboardingLocationState>(
        listenWhen: (prev, curr) {
          return prev.status != curr.status;
        },
        listener: (context, state) {
          context.read<OnboardingCubit>().nextStep();
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(title: const Text("Location Permission")),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "To tag the location where you ate or drank your plate, we need access to your location permission",
                  ),
                  ElevatedButton(
                    onPressed: () => context
                        .read<OnboardingLocationCubit>()
                        .requestPermission(),
                    child: const Text("Allow"),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
