import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:dishes_api/dishes_api.dart';
import 'package:image_storage_api/image_storage_api.dart';
import 'package:isar/isar.dart';
import 'package:path/path.dart';
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

  /// ───────────── Export DB ─────────────
  /// Returns the path to the exported Isar database file
  @override
  Future<String> exportDb() async {
    // Isar keeps the main DB file in its directory
    final dbPath = _isar.directory;
    final files = Directory(dbPath!).listSync().whereType<File>().toList();

    // Find the main Isar DB file
    final dbFile = files.firstWhere(
      (f) => extension(f.path) == '.isar',
      orElse: () => throw Exception('Isar DB file not found'),
    );

    return dbFile.path;
  }

  /// ───────────── Import DB ─────────────
  /// Replaces current Isar DB with the given file path
  @override
  Future<void> importDb(String path) async {
    final dbFile = File(path);
    if (!await dbFile.exists()) {
      throw Exception('DB file not found at $path');
    }

    // Copy file into Isar directory (overwrite existing)
    final dbDir = Directory(_isar.directory!);
    final destFile = File(join(dbDir.path, basename(path)));
    await dbFile.copy(destFile.path);

    await _isar.close();

    _isar = await Isar.open([DishSchema], directory: dbDir.path);

    final dishes = await _isar.dishs.where().findAll();
    _dishStreamController.add(dishes);
  }
}
