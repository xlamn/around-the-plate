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

  Future<String> exportDb() => _dishesApi.exportDb();

  Future<void> importDb(String path) => _dishesApi.importDb(path);
}
