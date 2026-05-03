import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:dishes_api/dishes_api.dart';
import 'package:image_storage_api/image_storage_api.dart';
import 'package:isar/isar.dart';
import 'package:rxdart/subjects.dart';

class IsarStorageDishesApi extends DishesApi {
  IsarStorageDishesApi({
    required Isar isar,
    required ImageStorageApi imageStorageApi,
  }) : _isar = isar,
       _imageStorageApi = imageStorageApi {
    _init();
  }

  Isar _isar;
  final ImageStorageApi _imageStorageApi;

  late final _dishStreamController = BehaviorSubject<List<Dish>>.seeded([]);

  void _init() async {
    final dishes = await _isar.dishs.where().findAll();
    _dishStreamController.add(dishes);
  }

  @override
  Stream<List<Dish>> getDishes() => _dishStreamController.asBroadcastStream();

  @override
  Future<void> saveDish(Dish dish) async {
    String imagePath = dish.imagePath;
    if (!await File(imagePath).exists()) {
      imagePath = dish.imagePath;
    } else {
      imagePath = await _imageStorageApi.saveImage(File(dish.imagePath));
    }

    final updatedDish = dish.copyWith(imagePath: imagePath);

    await _isar.writeTxn(() async {
      await _isar.dishs.put(updatedDish);
    });

    final dishes = await _isar.dishs.where().findAll();
    _dishStreamController.add(dishes);
  }

  @override
  Future<Dish?> getDish(int id) async {
    return await _isar.dishs.get(id);
  }

  @override
  Future<void> deleteDish(int id) async {
    final dish = await _isar.dishs.filter().idEqualTo(id).findFirst();
    if (dish == null) {
      log('Dish with id $id not found');
      return;
    }

    await _isar.writeTxn(() async {
      await _isar.dishs.delete(dish.id);
    });

    await _imageStorageApi.deleteImage(dish.imagePath);

    final dishes = await _isar.dishs.where().findAll();
    _dishStreamController.add(dishes);
  }

  @override
  Future<void> close() async {
    await _dishStreamController.close();
  }

  @override
  Future<Uint8List?> exportDb() async {
    final dishes = await _isar.dishs.where().findAll();
    if (dishes.isEmpty) return null;
    return File(_isar.path!).readAsBytes();
  }

  @override
  Future<void> importDb(Uint8List dbBytes) async {
    final dirPath = _isar.directory!;
    final dbFile = File(_isar.path!);

    await _isar.close();
    await dbFile.writeAsBytes(dbBytes, flush: true);

    _isar = await Isar.open([DishSchema], directory: dirPath);

    final dishes = await _isar.dishs.where().findAll();
    _dishStreamController.add(dishes);
  }
}
