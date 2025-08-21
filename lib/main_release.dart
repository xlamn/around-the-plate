import 'package:dishes_api/dishes_api.dart';
import 'package:flutter/material.dart';
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

  final dishesApi = IsarStorageDishesApi(
    isar: isar,
  );

  bootstrap(dishesApi: dishesApi);
}
