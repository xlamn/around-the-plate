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
      child: BlocBuilder<OnboardingCameraCubit, OnboardingCameraState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(title: const Text("Camera Permission")),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("We need access to your camera"),
                ElevatedButton(
                  onPressed: () => context
                      .read<OnboardingCameraCubit>()
                      .requestCameraPermission(),
                  child: const Text("Allow"),
                ),
                if (state.status == CameraPermissionStatus.granted)
                  ElevatedButton(
                    onPressed: () => context.read<OnboardingCubit>().nextStep(),
                    child: const Text("Continue"),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
