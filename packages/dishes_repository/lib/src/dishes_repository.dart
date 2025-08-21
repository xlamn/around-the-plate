import 'package:dishes_api/dishes_api.dart';

class DishesRepository {
  const DishesRepository({
    required DishesApi dishesApi,
  }) : _dishesApi = dishesApi;

  final DishesApi _dishesApi;

  Stream<List<Dish>> getDishes() => _dishesApi.getDishes();

  Future<void> saveDish(Dish dish) => _dishesApi.saveDish(dish);

  Future<void> deleteDish(int id) => _dishesApi.deleteDish(id);

  void dispose() => _dishesApi.close();
}
