import 'package:app_theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../cubit/onboarding_cubit.dart';
import '../cubit/onboarding_location_cubit.dart';

class OnboardingLocationPage extends StatelessWidget {
  const OnboardingLocationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => OnboardingLocationCubit(),
      child: OnboardingLocationView(),
    );
  }
}

class OnboardingLocationView extends StatelessWidget {
  const OnboardingLocationView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OnboardingLocationCubit, OnboardingLocationState>(
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
              children: [
                Expanded(
                  child: Container(
                    color: Colors.transparent,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(AppSizes.spacing24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: AppSizes.spacing8,
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
                  padding: const EdgeInsets.all(AppSizes.spacing16),
                  child: FButton(
                    onPress: () => context
                        .read<OnboardingLocationCubit>()
                        .requestLocationPermission(),
                    child: const Text('Continue'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
