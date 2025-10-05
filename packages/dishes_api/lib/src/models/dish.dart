import 'package:equatable/equatable.dart';
import 'package:isar/isar.dart';

import 'dish_category.dart';
import 'dish_location.dart';

part 'dish.g.dart';

@Collection(inheritance: false)
class Dish extends Equatable {
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

  final DishLocation? location;

  final DateTime lastModifiedDate;

  Dish({
    required this.name,
    required this.imagePath,
    required this.rating,
    DishCategory? category,
    this.origin,
    this.date,
    this.location,
  }) : categoryValue = category?.index,
       lastModifiedDate = DateTime.now();

  Dish copyWith({
    String? name,
    String? imagePath,
    DishCategory? category,
    String? origin,
    double? rating,
    DateTime? date,
    DishLocation? location,
  }) {
    return Dish(
      name: name ?? this.name,
      imagePath: imagePath ?? this.imagePath,
      category: category ?? this.category,
      origin: origin ?? this.origin,
      rating: rating ?? this.rating,
      date: date ?? this.date,
      location: location ?? this.location,
    );
  }

  @ignore
  @override
  List<Object?> get props => [
    name,
    lastModifiedDate,
  ];
}
