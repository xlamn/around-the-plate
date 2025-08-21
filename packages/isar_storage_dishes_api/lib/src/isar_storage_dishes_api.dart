import 'dart:async';

import 'package:dishes_api/dishes_api.dart';
import 'package:isar/isar.dart';
import 'package:rxdart/subjects.dart';

class IsarStorageDishesApi extends DishesApi {
  /// {@macro isar_storage_dishes_api}
  IsarStorageDishesApi({
    required Isar isar,
  }) : _isar = isar {
    _init();
  }

  final Isar _isar;

  late final _dishStreamController = BehaviorSubject<List<Dish>>.seeded([]);

  void _init() async {
    final dishes = await _isar.dishs.where().findAll();
    _dishStreamController.add(dishes);
  }

  @override
  Stream<List<Dish>> getDishes() => _dishStreamController.asBroadcastStream();

  @override
  Future<void> saveDish(Dish dish) async {
    await _isar.writeTxn(() async {
      await _isar.dishs.put(dish);
    });
    final dishes = await _isar.dishs.where().findAll();
    _dishStreamController.add(dishes);
  }

  @override
  Future<void> deleteDish(int id) async {
    final dish = await _isar.dishs.filter().idEqualTo(id).findFirst();
    if (dish == null) {
      print('Dish with id $id not found');
    }

    await _isar.writeTxn(() async {
      await _isar.dishs.delete(dish!.id);
    });

    final dishes = await _isar.dishs.where().findAll();
    _dishStreamController.add(dishes);
  }

  @override
  Future<void> close() async {
    await _dishStreamController.close();
    // Note: Do not close the Isar instance unless you’re done using it globally.
  }
}
