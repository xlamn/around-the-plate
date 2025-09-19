import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

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
                    "Yay, you are ready!",
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
              padding: const EdgeInsets.all(16.0),
              child: FButton(
                prefix: Icon(FIcons.partyPopper),
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
