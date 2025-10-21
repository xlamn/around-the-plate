import 'dart:io';

import 'package:image_storage_api/image_storage_api.dart';
import 'package:path/path.dart' as path;

class DirectoryImageStorageApi extends ImageStorageApi {
  const DirectoryImageStorageApi._internal();

  static const DirectoryImageStorageApi instance =
      DirectoryImageStorageApi._internal();

  static String? _directory;

  static Future<void> init(String dir) async {
    _directory = dir;
  }

  String get directory {
    if (_directory == null) {
      throw StateError('DirectoryImageStorageApi.init() must be called first.');
    }
    return _directory!;
  }

  @override
  Future<String> saveImage(File sourceFile) async {
    final fileName = path.basename(sourceFile.path);
    await sourceFile.copy('$directory/$fileName');
    return fileName;
  }

  @override
  Future<void> deleteImage(String imagePath) async {
    final file = File('$directory/$imagePath');
    if (await file.exists()) await file.delete();
  }

  @override
  File? getImageFile(String imagePath) {
    final file = File('$directory/$imagePath');
    return file.existsSync() ? file : null;
  }

  @override
  Future<List<int>?> readImageBytes(String imagePath) async {
    final file = getImageFile(imagePath);
    if (file == null) return null;
    return await file.readAsBytes();
  }
}
