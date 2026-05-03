import 'package:equatable/equatable.dart';
import 'package:isar/isar.dart';

part 'trip.g.dart';

@Collection(inheritance: false)
class Trip extends Equatable {
  final Id id;
  final String name;
  final String? description;
  final String coverImagePath;
  final List<int> dishIds;
  final DateTime createdDate;
  final DateTime lastModifiedDate;

  const Trip({
    this.id = Isar.autoIncrement,
    required this.name,
    this.description,
    required this.coverImagePath,
    required this.dishIds,
    required this.createdDate,
    required this.lastModifiedDate,
  });

  factory Trip.create({
    required String name,
    String? description,
    required String coverImagePath,
    List<int> dishIds = const [],
  }) {
    final now = DateTime.now();
    return Trip(
      name: name,
      description: description,
      coverImagePath: coverImagePath,
      dishIds: dishIds,
      createdDate: now,
      lastModifiedDate: now,
    );
  }

  Trip copyWith({
    String? name,
    String? description,
    String? coverImagePath,
    List<int>? dishIds,
  }) {
    return Trip(
      id: id,
      name: name ?? this.name,
      description: description ?? this.description,
      coverImagePath: coverImagePath ?? this.coverImagePath,
      dishIds: dishIds ?? this.dishIds,
      createdDate: createdDate,
      lastModifiedDate: DateTime.now(),
    );
  }

  @ignore
  @override
  List<Object?> get props => [id, name, lastModifiedDate];
}
