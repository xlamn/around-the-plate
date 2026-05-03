import 'dart:typed_data';

import 'models/models.dart';

abstract class TripsApi {
  const TripsApi();

  Stream<List<Trip>> getTrips();

  Future<void> saveTrip(Trip trip);

  Future<Trip?> getTrip(int id);

  Future<void> deleteTrip(int id);

  Future<Uint8List?> exportDb();

  Future<void> importDb(Uint8List dbBytes);

  Future<void> close();
}
