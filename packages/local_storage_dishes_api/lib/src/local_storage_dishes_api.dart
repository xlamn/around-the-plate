import 'package:dishes_api/dishes_api.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageDishesApi extends DishesApi {
  LocalStorageDishesApi({
    required SharedPreferences plugin,
  }) : _plugin = plugin;

  final SharedPreferences _plugin;

  late final _dishStreamController = BehaviorSubject<List<Dish>>.seeded(
    const [],
  );

  @override
  Future<void> close() {
    return _dishStreamController.close();
  }
}
