import 'package:flutter/material.dart';
import 'package:local_storage_dishes_api/local_storage_dishes_api.dart';

import 'bootstrap.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final dishesApi = LocalStorageDishesApi(
    plugin: await SharedPreferences.getInstance(),
  );

  bootstrap(dishesApi: dishesApi);
}
