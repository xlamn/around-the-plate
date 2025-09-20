import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forui/forui.dart';
import '../../../cubit/onboarding_cubit.dart';
import '../cubit/onboarding_camera_cubit.dart';
import '../cubit/onboarding_camera_state.dart';

class OnboardingCameraPage extends StatelessWidget {
  const OnboardingCameraPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => OnboardingCameraCubit(),
      child: BlocConsumer<OnboardingCameraCubit, OnboardingCameraState>(
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
                  Expanded(
                    child: Container(
                      color: Colors.transparent,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 8.0,
                      children: [
                        Text(
                          "Capture The Moment",
                          style: Theme.of(context).textTheme.headlineSmall
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        Text(
                          'To take photos of your dishes, the app requires access to your phone\'s camera first.',
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
                          .read<OnboardingCameraCubit>()
                          .requestCameraPermission(),
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
