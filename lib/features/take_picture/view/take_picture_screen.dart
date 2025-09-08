import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:image_picker/image_picker.dart';

class TakePictureScreen extends StatefulWidget {
  const TakePictureScreen({super.key, required this.camera});

  final CameraDescription camera;

  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

class TakePictureScreenState extends State<TakePictureScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    _controller = CameraController(
      widget.camera,
      ResolutionPreset.high,
    );
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Take a picture of your plate'),
      ),
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Column(
              children: [
                Flexible(
                  child: CameraPreview(
                    _controller,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    FButton.icon(
                      onPress: () async {
                        final imagePath = await _openGallery();
                        if (!context.mounted && imagePath == null) return;
                        Navigator.pop(context, imagePath);
                      },
                      child: Icon(FIcons.image),
                    ),
                    FButton.icon(
                      onPress: () async {
                        final imagePath = await _takePicture(context);
                        if (!context.mounted) return;
                        Navigator.pop(context, imagePath);
                      },
                      child: Icon(FIcons.camera),
                    ),
                  ],
                ),
              ],
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  Future<String?> _openGallery() async {
    final picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    return image?.path;
  }

  Future<String> _takePicture(BuildContext context) async {
    // Ensure that the camera is initialized.
    await _initializeControllerFuture;
    final image = await _controller.takePicture();
    return image.path;
  }
}
