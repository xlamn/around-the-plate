import 'dart:io';

abstract class ImageStorageApi {
  const ImageStorageApi();

  Future<String> saveImage(File sourceFile);

  Future<void> deleteImage(String? imagePath);
}
