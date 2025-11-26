import 'package:dishes_repository/dishes_repository.dart';

import 'cloud_sync_api.dart';

/// Service to orchestrate manual cloud synchronization of local data.
class CloudSyncService {
  CloudSyncService({
    required this.repository,
    required this.cloudApi,
  });

  final DishesRepository repository;

  final CloudSyncApi cloudApi;

  Future<SyncResult> sync() async {
    try {
      final localDbPath = await repository.exportDb();
      final result = await cloudApi.sync(localDbPath: localDbPath);

      //If data was downloaded from cloud, import it back into repository
      if (result.direction == SyncDirection.download) {
        await repository.importDb(localDbPath);
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

  Future<void> login() async {
    await cloudApi.login();
  }

  Future<void> logout() async {
    await cloudApi.logout();
  }

  Future<bool> isSignedIn() async {
    return cloudApi.isSignedIn();
  }
}
