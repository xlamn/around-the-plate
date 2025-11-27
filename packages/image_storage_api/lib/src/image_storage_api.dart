import 'dart:io';

abstract class ImageStorageApi {
  const ImageStorageApi();

  String get directory;

  /// Saves File and returns the image path where file is stored.
  Future<String> saveImage(File sourceFile);

  /// Deletes File for the given stored image path.
  Future<void> deleteImage(String imagePath);

  /// Returns a File for the given stored image path, or null if it doesn't exist.
  File? getImageFile(String imagePath);

  /// Reads and returns the raw bytes for the stored image, or null if not found.
  Future<List<int>?> readImageBytes(String imagePath);

  List<String> listLocalImages();
}
