abstract class CloudSyncApi {
  Future<void> login();

  Future<void> logout();

  Future<SyncResult> sync({required String localDbPath});

  Future<bool> isSignedIn();
}

class SyncResult {
  final bool success;
  final String? message;
  final SyncDirection? direction;

  SyncResult({required this.success, this.message, this.direction});
}

enum SyncDirection { upload, download, none }

class SyncException implements Exception {
  final String message;

  SyncException([this.message = 'A sync error occurred']);

  @override
  String toString() => 'SyncException: $message';
}
