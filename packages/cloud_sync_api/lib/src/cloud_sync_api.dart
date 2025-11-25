abstract class CloudSyncApi {
  /// Initialize required clients (OAuth, iCloud container, etc.).
  Future<void> initialize();

  /// Upload local Isar database file to remote storage.
  Future<void> uploadDatabase({required String localDbPath});

  /// Download remote database file into local storage.
  Future<void> downloadDatabase({required String localDbPath});

  /// Check if a remote database exists.
  Future<bool> remoteDatabaseExists();

  /// Returns last modified timestamps for conflict resolution.
  Future<DateTime?> getRemoteLastModified();
  Future<DateTime?> getLocalLastModified(String localDbPath);

  /// Performs full sync (upload or download based on timestamps).
  Future<SyncResult> sync({required String localDbPath});
}

class SyncResult {
  final bool success;
  final SyncDirection? direction;
  final String? message;

  SyncResult({
    required this.success,
    this.direction,
    this.message,
  });
}

enum SyncDirection {
  upload,
  download,
}

class SyncException implements Exception {
  final String message;
  SyncException(this.message);

  @override
  String toString() => 'SyncException: $message';
}
