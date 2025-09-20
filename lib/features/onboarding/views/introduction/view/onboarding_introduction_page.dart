import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forui/forui.dart';
import '../../../cubit/onboarding_cubit.dart';

class OnboardingIntroductionPage extends StatelessWidget {
  const OnboardingIntroductionPage({super.key});

  @override
  Widget build(BuildContext context) {
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
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 8.0,
                children: [
                  Text(
                    "Welcome to Around The Plate",
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Around The Plate is your companion to capture your experiences with different foods and drinks.',
                    style: Theme.of(
                      context,
                    ).textTheme.bodyLarge,
                  ),
                  Text(
                    'Shoot a photo in the moment, hold onto the details and rate it.',
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
                prefix: Icon(FIcons.play),
                onPress: () => context.read<OnboardingCubit>().nextStep(),
                child: const Text('Start'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
