import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
            appBar: AppBar(title: const Text("Camera Permission")),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "To take photos and videos of your dishes, we need access to your camera permission",
                  ),
                  ElevatedButton(
                    onPressed: () => context
                        .read<OnboardingCameraCubit>()
                        .requestCameraPermission(),
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
