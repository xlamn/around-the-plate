import 'dart:typed_data';

import 'package:dishes_api/src/models/dish.dart';

abstract class DishesApi {
  const DishesApi();

  Stream<List<Dish>> getDishes();

  Future<void> saveDish(Dish dish);

  Future<Dish?> getDish(int id);

  Future<void> deleteDish(int id);

  Future<void> close();

  Future<Uint8List> exportDb();

  Future<void> importDb(Uint8List path);
}
