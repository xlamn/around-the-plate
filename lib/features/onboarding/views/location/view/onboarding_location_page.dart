import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forui/forui.dart';
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
            body: SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Placeholder(
                    fallbackHeight: 600,
                  ),
                  Spacer(),
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 8.0,
                      children: [
                        Text(
                          "All Around The World",
                          style: Theme.of(context).textTheme.headlineSmall
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        Text(
                          'Every dish has its history. In order to provide you with map related features, the app needs access to your location permission.  ',
                          style: Theme.of(
                            context,
                          ).textTheme.bodyLarge,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: FButton(
                      onPress: () => context
                          .read<OnboardingLocationCubit>()
                          .requestPermission(),
                      child: const Text('Continue'),
                    ),
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

             // const Text(
                  //   "To tag the location where you ate or drank your plate, we need access to your location permission",
                  // ),
                  // ElevatedButton(
                  //   onPressed: () => context
                  //       .read<OnboardingLocationCubit>()
                  //       .requestPermission(),
                  //   child: const Text("Allow"),
                  // ),