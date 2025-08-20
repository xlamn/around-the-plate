import 'package:dishes_api/dishes_api.dart';

class DishesRepository {
  const DishesRepository({
    required DishesApi dishesApi,
  }) : _dishesApi = dishesApi;

  final DishesApi _dishesApi;

  void dispose() => _dishesApi.close();
}
