import 'dart:io';
import 'dart:typed_data';

import 'package:image_storage_api/image_storage_api.dart';
import 'package:isar/isar.dart';
import 'package:rxdart/subjects.dart';
import 'package:trips_api/trips_api.dart';

class IsarStorageTripsApi extends TripsApi {
  IsarStorageTripsApi({
    required Isar isar,
    required ImageStorageApi imageStorageApi,
  }) : _isar = isar,
       _imageStorageApi = imageStorageApi {
    _init();
  }

  Isar _isar;
  final ImageStorageApi _imageStorageApi;

  late final _tripsStreamController = BehaviorSubject<List<Trip>>.seeded([]);

  void _init() async {
    final trips = await _isar.trips.where().findAll();
    _tripsStreamController.add(trips);
  }

  @override
  Stream<List<Trip>> getTrips() => _tripsStreamController.asBroadcastStream();

  @override
  Future<void> saveTrip(Trip trip) async {
    String coverImagePath = trip.coverImagePath;

    // Only copy the image if it's an absolute path (new gallery image, not already managed)
    if (coverImagePath.startsWith('/')) {
      final file = File(coverImagePath);
      if (await file.exists()) {
        coverImagePath = await _imageStorageApi.saveImage(file);
      }
    }

    final updatedTrip = trip.copyWith(coverImagePath: coverImagePath);

    await _isar.writeTxn(() async {
      await _isar.trips.put(updatedTrip);
    });

    final trips = await _isar.trips.where().findAll();
    _tripsStreamController.add(trips);
  }

  @override
  Future<Trip?> getTrip(int id) async {
    return await _isar.trips.get(id);
  }

  @override
  Future<void> deleteTrip(int id) async {
    await _isar.writeTxn(() async {
      await _isar.trips.delete(id);
    });

    final trips = await _isar.trips.where().findAll();
    _tripsStreamController.add(trips);
  }

  @override
  Future<Uint8List?> exportDb() async {
    final trips = await _isar.trips.where().findAll();
    if (trips.isEmpty) return null;
    return File(_isar.path!).readAsBytes();
  }

  @override
  Future<void> importDb(Uint8List dbBytes) async {
    final dirPath = _isar.directory!;
    final dbFile = File(_isar.path!);

    await _isar.close();
    await dbFile.writeAsBytes(dbBytes, flush: true);

    _isar = await Isar.open([TripSchema], directory: dirPath, name: 'trips');

    final trips = await _isar.trips.where().findAll();
    _tripsStreamController.add(trips);
  }

  @override
  Future<void> close() async {
    await _tripsStreamController.close();
  }
}
