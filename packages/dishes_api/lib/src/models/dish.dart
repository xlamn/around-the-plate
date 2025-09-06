import 'package:dishes_api/src/models/dish_category.dart';
import 'package:isar/isar.dart';

part 'dish.g.dart';

@collection
class Dish {
  Id id = Isar.autoIncrement;

  final String name;

  final String imagePath;

  @enumerated
  final DishCategory category;

  final String origin;

  final DateTime date;

  final double rating;

  Dish({
    required this.name,
    required this.imagePath,
    required this.category,
    required this.origin,
    required this.date,
    required this.rating,
  });
}
