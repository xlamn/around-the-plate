import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

import '../../features/add_plate/add_plate_bottom_sheet.dart';
import '../../features/take_picture/take_picture_screen.dart';

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
          final imagePath = await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => TakePictureScreen(
                camera: firstCamera,
              ),
            ),
          );

          if (!context.mounted) return;

          if (imagePath != null) {
            showModalBottomSheet(
              context: context,
              isDismissible: false,
              enableDrag: false,
              builder: (_) => AddPlateScreen(
                imagePath: imagePath,
              ),
            );
          }
        },
        child: const Text('Add New Plate'),
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
