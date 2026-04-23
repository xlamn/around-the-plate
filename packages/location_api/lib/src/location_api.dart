import 'package:dishes_api/dishes_api.dart';

abstract class LocationApi {
  const LocationApi();

  Future<DishLocation?> getCurrentLocation();

  Future<List<DishLocation>> searchLocations(
    String query, {
    DishLocation? currentLocation,
  });
}
