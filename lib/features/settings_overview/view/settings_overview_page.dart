import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

class SettingsOverviewPage extends StatelessWidget {
  const SettingsOverviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 5),
        FCard(
          title: const Text('Account'),
          subtitle: const Text(
            'Make changes to your account here. Click save when you are done.',
          ),
          child: Column(
            children: [
              const FTextField(label: Text('Name'), hint: 'John Renalo'),
              const SizedBox(height: 10),
              const FTextField(label: Text('Email'), hint: 'john@doe.com'),
              const SizedBox(height: 16),
              FButton(onPress: () {}, child: const Text('Save')),
            ],
          ),
        ),
      ],
    );
  }
}
