import 'package:equatable/equatable.dart';
import 'package:isar/isar.dart';

import 'dish_category.dart';
import 'dish_cuisine.dart';
import 'dish_location.dart';

part 'dish.g.dart';

@Collection(inheritance: false)
class Dish extends Equatable {
  final Id id;

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

  /// Constructor intended for Isar. Prefer to use `Dish.create()` to create a dish.
  const Dish({
    this.id = Isar.autoIncrement,
    required this.name,
    required this.imagePath,
    required this.rating,
    this.categoryValue,
    this.cuisineValue,
    this.date,
    this.location,
    required this.lastModifiedDate,
  });

  factory Dish.create({
    Id id = Isar.autoIncrement,
    required String name,
    required String imagePath,
    required double rating,
    DishCategory? category,
    DishCuisine? cuisine,
    DateTime? date,
    DishLocation? location,
  }) {
    return Dish(
      id: id,
      name: name,
      imagePath: imagePath,
      rating: rating,
      categoryValue: category?.index,
      cuisineValue: cuisine?.index,
      date: date,
      location: location,
      lastModifiedDate: DateTime.now(),
    );
  }

  Dish copyWith({
    Id? id,
    String? name,
    String? imagePath,
    DishCategory? category,
    DishCuisine? cuisine,
    double? rating,
    DateTime? date,
    DishLocation? location,
  }) {
    return Dish(
      id: id ?? this.id,
      name: name ?? this.name,
      imagePath: imagePath ?? this.imagePath,
      categoryValue: category?.index ?? categoryValue,
      cuisineValue: cuisine?.index ?? cuisineValue,
      rating: rating ?? this.rating,
      date: date ?? this.date,
      location: location ?? this.location,
      lastModifiedDate: lastModifiedDate,
    );
  }

  @ignore
  @override
  List<Object?> get props => [
    id,
    name,
    lastModifiedDate,
  ];
}
