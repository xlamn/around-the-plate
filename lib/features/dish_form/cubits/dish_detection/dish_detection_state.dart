part of 'dish_detection_cubit.dart';

enum DishDetectionStatus { idle, detecting, detected, notFood }

final class DishDetectionState {
  const DishDetectionState({
    this.status = DishDetectionStatus.idle,
    this.name,
  });

  final DishDetectionStatus status;
  final String? name;

  DishDetectionState copyWith({DishDetectionStatus? status, String? name}) {
    return DishDetectionState(
      status: status ?? this.status,
      name: name ?? this.name,
    );
  }
}
