import 'package:directory_image_storage_api/directory_image_storage_api.dart';
import 'package:dishes_api/dishes_api.dart';
import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:isar_storage_dishes_api/isar_storage_dishes_api.dart';
import 'package:path_provider/path_provider.dart';

import 'bootstrap.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final dir = await getApplicationDocumentsDirectory();

  final isar = await Isar.open(
    [DishSchema],
    directory: dir.path,
  );

  // await isar.writeTxn(() async => await isar.clear());

  await DirectoryImageStorageApi.init(dir.path);
  final imageStorage = DirectoryImageStorageApi.instance;

  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: HydratedStorageDirectory(
      dir.path,
    ),
  );

  final dishesApi = IsarStorageDishesApi(
    isar: isar,
    imageStorageApi: imageStorage,
  );

  bootstrap(dishesApi: dishesApi);
}
