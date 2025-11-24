import 'package:app_theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../cubit/onboarding_cubit.dart';

class OnboardingIntroductionPage extends StatelessWidget {
  const OnboardingIntroductionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Spacer(),
            ShaderMask(
              shaderCallback: (rect) {
                return LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black,
                    Colors.black,
                    Colors.transparent,
                  ],
                  stops: [
                    0.0,
                    0.2,
                    0.8,
                    1.0,
                  ],
                ).createShader(Rect.fromLTRB(0, 0, rect.width, rect.height));
              },
              blendMode: BlendMode.dstIn,
              child: Image.asset(
                'assets/onboarding/onboarding_01.png',
              ),
            ),
            Spacer(),
            Padding(
              padding: const EdgeInsets.all(AppSizes.spacing24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: AppSizes.spacing8,
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
              padding: const EdgeInsets.all(AppSizes.spacing16),
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
