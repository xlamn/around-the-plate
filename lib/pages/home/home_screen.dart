import 'package:around_the_plate/features/take_picture/take_picture_screen.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FButton(
        onPress: () async {
          final cameras = await availableCameras();
          final firstCamera = cameras.first;
          if (!context.mounted) return;
          await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => TakePictureScreen(
                camera: firstCamera,
              ),
            ),
          );
        },
        child: const Text('Create new entry'),
      ),
      body: Column(
        spacing: 16.0,
        children: [
          FCard(
            title: const Text('Dish 1'),
            subtitle: const Text(
              'Make changes to your account here. Click save when you are done.',
            ),
          ),
          FCard(
            title: const Text('Dish 2'),
            subtitle: const Text(
              'Make changes to your account here. Click save when you are done.',
            ),
          ),
        ],
      ),
    );
  }
}
