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
                prefix: const Icon(FIcons.partyPopper),
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
