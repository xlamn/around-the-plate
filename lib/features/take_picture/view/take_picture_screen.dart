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
            return CameraPreview(
              _controller,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        onTap: () async {
                          final imagePath = await _openGallery();
                          if (!context.mounted || imagePath == null) {
                            return;
                          }
                          Navigator.pop(context, imagePath);
                        },
                        child: Icon(
                          FIcons.image,
                          color: Colors.white,
                          size: 36.0,
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          final imagePath = await _takePicture(context);
                          if (!context.mounted) return;
                          Navigator.pop(context, imagePath);
                        },
                        child: Container(
                          margin: EdgeInsets.all(32.0),
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 8.0,
                              color: Colors.white,
                            ),
                            borderRadius: BorderRadius.circular(100.0),
                          ),
                        ),
                      ),
                      SizedBox.square(
                        dimension: 36.0,
                      ),
                    ],
                  ),
                ],
              ),
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
