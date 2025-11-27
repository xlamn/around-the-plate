import 'dart:developer';

import 'package:dishes_repository/dishes_repository.dart';

import 'cloud_sync_api.dart';

/// Service which handles the flow between the repository and cloud API
class CloudSyncService {
  CloudSyncService({
    required this.repository,
    required this.cloudApi,
  });

  final DishesRepository repository;
  final CloudSyncApi cloudApi;

  Future<SyncResult> sync() async {
    try {
      final db = await repository.exportDb();
      final result = await cloudApi.sync(localDb: db);

      if (result.direction == SyncDirection.download) {
        await repository.importDb(result.downloadedBytes!);
      }

      return result;
    } catch (e) {
      log(e.toString());
      return SyncResult(
        success: false,
        message: e.toString(),
        direction: SyncDirection.none,
      );
    }
  }

  Future<void> login() async => await cloudApi.login();

  Future<void> logout() async => await cloudApi.logout();

  Future<bool> isSignedIn() async => await cloudApi.isSignedIn();
}
