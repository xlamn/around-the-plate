import 'dart:io';

import 'package:directory_image_storage_api/directory_image_storage_api.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late Directory directory;
  late DirectoryImageStorageApi api;

  setUp(() async {
    directory = await Directory.systemTemp.createTemp('image_storage_test');
    await DirectoryImageStorageApi.init(directory.path);
    api = DirectoryImageStorageApi.instance;
  });

  tearDown(() async {
    await directory.delete(recursive: true);
  });

  group('`$DirectoryImageStorageApi`', () {
    test('returns null if file does not exist', () {
      final file = api.getImageFile('nonexistent.png');
      expect(file, isNull);
    });

    test('saves and retrieves image as bytes', () async {
      final source = File('${directory.path}/source.jpg');
      await source.writeAsBytes([1, 2, 3]);

      final fileName = await api.saveImage(source);
      final retrieved = api.readImageBytes(fileName);

      expect(await retrieved, equals([1, 2, 3]));
    });

    test('saves and retrieves image as file', () async {
      final imagePath = '${directory.path}/test_image.jpg';
      final source = File(imagePath);
      await source.writeAsBytes([1, 2, 3]);

      final file = api.getImageFile('test_image.jpg');

      expect(file, isNotNull);
      expect(file!.existsSync(), isTrue);
      expect(file.path, equals(imagePath));
    });

    test('deletes image', () async {
      final file = File('${directory.path}/to_delete.jpg');
      await file.writeAsBytes([9, 9, 9]);

      await api.deleteImage('to_delete.jpg');
      expect(await file.exists(), isFalse);
    });
  });
}
