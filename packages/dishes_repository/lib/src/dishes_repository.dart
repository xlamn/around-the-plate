import 'dart:typed_data';

import 'package:dishes_api/dishes_api.dart';

class DishesRepository {
  const DishesRepository({
    required DishesApi dishesApi,
  }) : _dishesApi = dishesApi;

  final DishesApi _dishesApi;

  Stream<List<Dish>> getDishes() => _dishesApi.getDishes();

  Future<void> saveDish(Dish dish) => _dishesApi.saveDish(dish);

  Future<Dish?> getDish(int id) => _dishesApi.getDish(id);

  Future<void> deleteDish(int id) => _dishesApi.deleteDish(id);

  void dispose() => _dishesApi.close();

  Future<Uint8List?> exportDb() => _dishesApi.exportDb();

  Future<void> importDb(Uint8List db) => _dishesApi.importDb(db);
}
