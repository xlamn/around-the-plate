import 'package:isar/isar.dart';

part 'dish_location.g.dart';

@embedded
class DishLocation {
  double? latitude;
  double? longitude;
  String? placeName;

  DishLocation({
    this.latitude,
    this.longitude,
    this.placeName,
  });
}
