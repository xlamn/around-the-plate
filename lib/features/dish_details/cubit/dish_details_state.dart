part of 'dish_details_cubit.dart';

enum DishDetailsStatus { initial, loading, success, failure, notFound }

class DishDetailsState extends Equatable {
  final DishDetailsStatus status;
  final Dish? dish;

  const DishDetailsState({
    required this.status,
    this.dish,
  });

  const DishDetailsState.initial() : this(status: DishDetailsStatus.initial);

  DishDetailsState copyWith({
    DishDetailsStatus? status,
    Dish? dish,
  }) {
    return DishDetailsState(
      status: status ?? this.status,
      dish: dish ?? this.dish,
    );
  }

  @override
  List<Object?> get props => [status, dish];
}
