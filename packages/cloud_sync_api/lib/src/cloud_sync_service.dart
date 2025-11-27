import 'dart:io';

import 'package:dishes_repository/dishes_repository.dart';
import 'package:image_storage_api/image_storage_api.dart';

import 'cloud_sync_api.dart';

/// Service which handles the flow between the repository and cloud API
class CloudSyncService {
  CloudSyncService({
    required this.repository,
    required this.cloudApi,
    required this.imageStorage,
  });

  final DishesRepository repository;
  final CloudSyncApi cloudApi;
  final ImageStorageApi imageStorage;

  Future<SyncResult> sync() async {
    try {
      final localDb = await repository.exportDb();
      final hasLocalDb = localDb != null;
      final result = await cloudApi.sync(localDb: localDb);

      if (!hasLocalDb && result.direction == SyncDirection.download) {
        await repository.importDb(result.downloadedBytes!);
        await cloudApi.downloadAllImages(imageStorage.directory);
      }

      if (hasLocalDb && result.direction == SyncDirection.upload) {
        final localImageFiles = Directory(imageStorage.directory).listSync();
        for (final entity in localImageFiles) {
          if (entity is File) {
            await cloudApi.uploadImage(entity);
          }
        }
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
