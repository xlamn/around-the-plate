import 'package:dishes_repository/dishes_repository.dart';
import 'package:trips_repository/trips_repository.dart';

import 'cloud_sync_api.dart';

/// Service which handles the flow the storage and cloud API
class CloudSyncService {
  CloudSyncService({
    required this.repository,
    required this.tripsRepository,
    required this.cloudApi,
    required this.imageStorageDirectory,
  });

  final DishesRepository repository;
  final TripsRepository tripsRepository;
  final CloudSyncApi cloudApi;
  final String imageStorageDirectory;

  static const _dishesDbKey = 'dishes.isar';
  static const _tripsDbKey = 'trips.isar';

  Future<SyncResult> sync() async {
    try {
      final result = await cloudApi.sync(
        databases: {
          _dishesDbKey: await repository.exportDb(),
          _tripsDbKey: await tripsRepository.exportDb(),
        },
        imageStorageDirectory: imageStorageDirectory,
      );

      if (result.direction == SyncDirection.download) {
        final dishesDb = result.downloadedDbs?[_dishesDbKey];
        if (dishesDb != null) await repository.importDb(dishesDb);
        final tripsDb = result.downloadedDbs?[_tripsDbKey];
        if (tripsDb != null) await tripsRepository.importDb(tripsDb);
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
