import 'package:dishes_api/src/models/dish.dart';

abstract class DishesApi {
  const DishesApi();

  Stream<List<Dish>> getDishes();

  Future<void> saveDish(Dish dish);

  Future<void> deleteDish(int id);

  Future<void> close();
}
