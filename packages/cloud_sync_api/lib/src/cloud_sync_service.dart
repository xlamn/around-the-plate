import 'package:dishes_repository/dishes_repository.dart';

import 'cloud_sync_api.dart';

/// Service which handles the flow the storage and cloud API
class CloudSyncService {
  CloudSyncService({
    required this.repository,
    required this.cloudApi,
    required this.imageStorageDirectory,
  });

  final DishesRepository repository;
  final CloudSyncApi cloudApi;
  final String imageStorageDirectory;

  Future<SyncResult> sync() async {
    try {
      final localDb = await repository.exportDb();
      final result = await cloudApi.sync(
        localDb: localDb,
        imageStorageDirectory: imageStorageDirectory,
      );
      if (result.direction == SyncDirection.download) {
        await repository.importDb(result.downloadedBytes!);
      }
      return result;
    } catch (e) {
      return SyncResult(
        success: false,
        message: e.toString(),
        direction: SyncDirection.none,
      );
    }
  }

  Future<void> login() async => await cloudApi.login();

  Future<void> logout() async => await cloudApi.logout();

  bool isSignedIn() => cloudApi.isSignedIn();
}
