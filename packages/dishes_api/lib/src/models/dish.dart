import 'package:dishes_api/src/models/dish_category.dart';
import 'package:isar/isar.dart';

part 'dish.g.dart';

@collection
class Dish {
  final Id id = Isar.autoIncrement;

  final String name;

  final String imagePath;

  final int? categoryValue;

  @ignore
  DishCategory? get category =>
      categoryValue != null ? DishCategory.values[categoryValue!] : null;

  final String? origin;

  final double rating;

  final DateTime? date;

  final DateTime lastModifiedDate;

  Dish({
    required this.name,
    required this.imagePath,
    required this.rating,
    DishCategory? category,
    this.origin,
    this.date,
  }) : categoryValue = category?.index,
       lastModifiedDate = DateTime.now();

  Dish copyWith({
    String? name,
    String? imagePath,
    DishCategory? category,
    String? origin,
    double? rating,
    DateTime? date,
  }) {
    return Dish(
      name: name ?? this.name,
      imagePath: imagePath ?? this.imagePath,
      category: category ?? this.category,
      origin: origin ?? this.origin,
      rating: rating ?? this.rating,
      date: date ?? this.date,
    );
  }
}
