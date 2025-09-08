import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:image_picker/image_picker.dart';

import '../../add_dish/view/add_dish_bottom_sheet.dart';
import '../../take_picture/view/take_picture_screen.dart';

class DishesOverviewAddButton extends StatelessWidget {
  const DishesOverviewAddButton({super.key});

  @override
  Widget build(BuildContext context) {
    return FButton(
      onPress: () async {
        final imagePath = await _getImagePath(context);
        if (!context.mounted || imagePath == null) return;

        await showModalBottomSheet(
          context: context,
          isDismissible: false,
          enableDrag: false,
          isScrollControlled: true,
          builder: (_) => AddDishBottomSheet(imagePath: imagePath),
        );
      },
      child: const Text('Add New Dish'),
    );
  }

  Future<String?> _getImagePath(BuildContext context) async {
    final cameras = await availableCameras();
    if (!context.mounted) return null;

    if (cameras.isEmpty) {
      return _openGallery(context);
    } else {
      return _openCamera(context, cameras);
    }
  }

  Future<String?> _openGallery(BuildContext context) async {
    final picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    return image?.path;
  }

  Future<String?> _openCamera(
    BuildContext context,
    List<CameraDescription> cameras,
  ) async {
    return Navigator.of(context).push<String>(
      MaterialPageRoute(
        builder: (context) => TakePictureScreen(camera: cameras.first),
      ),
    );
  }
}
