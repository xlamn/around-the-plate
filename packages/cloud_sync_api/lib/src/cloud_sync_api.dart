import 'dart:io';
import 'dart:typed_data';

abstract class CloudSyncApi {
  Future<void> login();

  Future<void> logout();

  Future<SyncResult> sync({required Uint8List? localDb});

  bool isSignedIn();

  Future<void> uploadImage(File file);

  Future<void> downloadAllImages(String localDirPath);
}

class SyncResult {
  final bool success;
  final String? message;
  final SyncDirection? direction;
  final Uint8List? downloadedBytes;

  SyncResult({
    required this.success,
    this.message,
    this.direction,
    this.downloadedBytes,
  });
}

enum SyncDirection { upload, download, none }

class SyncException implements Exception {
  final String message;

  SyncException([this.message = 'A sync error occurred']);

  @override
  String toString() => 'SyncException: $message';
}
