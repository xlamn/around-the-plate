import 'dart:typed_data';

import 'package:trips_api/trips_api.dart';

class TripsRepository {
  const TripsRepository({required TripsApi tripsApi}) : _tripsApi = tripsApi;

  final TripsApi _tripsApi;

  Stream<List<Trip>> getTrips() => _tripsApi.getTrips();

  Future<void> saveTrip(Trip trip) => _tripsApi.saveTrip(trip);

  Future<Trip?> getTrip(int id) => _tripsApi.getTrip(id);

  Future<void> deleteTrip(int id) => _tripsApi.deleteTrip(id);

  Future<Uint8List?> exportDb() => _tripsApi.exportDb();

  Future<void> importDb(Uint8List dbBytes) => _tripsApi.importDb(dbBytes);

  void dispose() => _tripsApi.close();
}
