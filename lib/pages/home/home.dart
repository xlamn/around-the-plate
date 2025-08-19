import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FButton(
        onPress: () {},
        child: const Text('Create new entry'),
      ),
      body: Placeholder(),
    );
  }
}
