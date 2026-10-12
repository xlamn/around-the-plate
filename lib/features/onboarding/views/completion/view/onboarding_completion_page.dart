import 'package:app_theme/app_theme.dart';
import 'package:flutter/material.dart';

class OnboardingCompletionPage extends StatelessWidget {
  final VoidCallback onFinished;

  const OnboardingCompletionPage({super.key, required this.onFinished});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Spacer(),
            ShaderMask(
              shaderCallback: (rect) {
                return const LinearGradient(
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
                'assets/onboarding/onboarding_04.jpg',
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.all(AppSizes.spacing24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: AppSizes.spacing8,
                children: [
                  Text(
                    'Yay, you are ready!',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Let\'s start! Explore the app by capturing your first dish. I\'m curious, what will it be?',
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
                prefix: const Icon(FLucideIcons.partyPopper),
                onPress: onFinished,
                child: const Text('Let\'s go'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
