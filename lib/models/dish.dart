import 'package:equatable/equatable.dart';

class Dish extends Equatable {
  final String name;
  final String imagePath;
  final String origin;
  final DateTime date;
  final double rating;

  const Dish({
    required this.name,
    required this.imagePath,
    required this.origin,
    required this.date,
    required this.rating,
  });

  @override
  List<Object?> get props => [name, imagePath];
}
