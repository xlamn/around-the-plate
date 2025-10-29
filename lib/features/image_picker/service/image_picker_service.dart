import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../view/take_picture_screen.dart';

/// Provides reusable functions for picking or taking images.
class ImagePickerService {
  const ImagePickerService._internal();

  static const ImagePickerService instance = ImagePickerService._internal();

  /// Opens either the camera or gallery depending on availability.
  Future<String?> pickImage(BuildContext context) async {
    final cameras = await availableCameras();
    if (!context.mounted) return null;

    if (cameras.isEmpty) {
      return _openGallery();
    } else {
      return _openCamera(context, cameras.first);
    }
  }

  Future<String?> _openGallery() async {
    final picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    return image?.path;
  }

  Future<String?> _openCamera(
    BuildContext context,
    CameraDescription camera,
  ) async {
    return Navigator.of(context).push<String>(
      MaterialPageRoute(
        builder: (context) => TakePictureScreen(camera: camera),
      ),
    );
  }
}
