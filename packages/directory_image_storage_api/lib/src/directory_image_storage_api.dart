import 'dart:io';

import 'package:image_storage_api/image_storage_api.dart';
import 'package:path/path.dart' as path;

class DirectoryImageStorageApi extends ImageStorageApi {
  final String directory;

  DirectoryImageStorageApi({required this.directory});

  @override
  Future<String> saveImage(File sourceFile) async {
    final fileName = path.basename(sourceFile.path);
    await sourceFile.copy('$directory/$fileName');

    return fileName;
  }

  @override
  Future<void> deleteImage(String? imagePath) async {
    if (imagePath == null) return;
    final file = File(imagePath);
    if (await file.exists()) await file.delete();
  }
}
