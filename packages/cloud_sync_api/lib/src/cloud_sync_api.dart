import 'dart:typed_data';

abstract class CloudSyncApi {
  Future<void> login();

  Future<void> logout();

  Future<SyncResult> sync({
    required Map<String, Uint8List?> databases,
    required String imageStorageDirectory,
  });

  bool isSignedIn();
}

class SyncResult {
  final bool success;
  final String? message;
  final SyncDirection? direction;
  final Map<String, Uint8List>? downloadedDbs;

  SyncResult({
    required this.success,
    this.message,
    this.direction,
    this.downloadedDbs,
  });
}

enum SyncDirection { upload, download, none }

class SyncException implements Exception {
  final String message;

  SyncException([this.message = 'A sync error occurred']);

  @override
  String toString() => 'SyncException: $message';
}
