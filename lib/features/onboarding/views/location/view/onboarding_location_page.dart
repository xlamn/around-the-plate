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
      child: BlocBuilder<OnboardingLocationCubit, OnboardingLocationState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(title: const Text("Location Permission")),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("We need access to your location"),
                ElevatedButton(
                  onPressed: () => context
                      .read<OnboardingLocationCubit>()
                      .requestPermission(),
                  child: const Text("Allow"),
                ),
                if (state.status == LocationPermissionStatus.granted)
                  ElevatedButton(
                    onPressed: () => context.read<OnboardingCubit>().nextStep(),
                    child: const Text("Finish"),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
