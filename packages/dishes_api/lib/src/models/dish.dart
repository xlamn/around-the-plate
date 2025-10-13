import 'package:equatable/equatable.dart';
import 'package:isar/isar.dart';

import 'dish_category.dart';
import 'dish_cuisine.dart';
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

  final int? cuisineValue;

  @ignore
  DishCuisine? get cuisine =>
      cuisineValue != null ? DishCuisine.values[cuisineValue!] : null;

  final double rating;

  final DateTime? date;

  final DishLocation? location;

  final DateTime lastModifiedDate;

  Dish({
    required this.name,
    required this.imagePath,
    required this.rating,
    this.categoryValue,
    this.cuisineValue,
    this.date,
    this.location,
  }) : lastModifiedDate = DateTime.now();

  Dish copyWith({
    String? name,
    String? imagePath,
    DishCategory? category,
    DishCuisine? cuisine,
    double? rating,
    DateTime? date,
    DishLocation? location,
  }) {
    return Dish(
      name: name ?? this.name,
      imagePath: imagePath ?? this.imagePath,
      categoryValue: category?.index ?? categoryValue,
      cuisineValue: cuisine?.index ?? cuisineValue,
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
