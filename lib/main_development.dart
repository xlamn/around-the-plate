import 'package:directory_image_storage_api/directory_image_storage_api.dart';
import 'package:dishes_api/dishes_api.dart';
import 'package:flutter/material.dart';
import 'package:isar_storage_dishes_api/isar_storage_dishes_api.dart';

import 'bootstrap.dart';
import 'utils/app_paths.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await AppPaths.init();

  final isar = await Isar.open(
    [DishSchema],
    directory: AppPaths.documentsDir,
  );

  // await isar.writeTxn(() async => await isar.clear());

  final imageStorageApi = DirectoryImageStorageApi(
    directory: AppPaths.documentsDir,
  );

  final dishesApi = IsarStorageDishesApi(
    isar: isar,
    imageStorageApi: imageStorageApi,
  );

  bootstrap(dishesApi: dishesApi);
}
