import 'package:flutter/material.dart';

class OnboardingCompletionPage extends StatelessWidget {
  final VoidCallback onFinished;

  const OnboardingCompletionPage({super.key, required this.onFinished});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("🎉 You are ready to go 🎉"),
            ElevatedButton(
              onPressed: onFinished,
              child: Text("Start"),
            ),
          ],
        ),
      ),
    );
  }
}
