part of 'add_dish_cubit.dart';

enum AddDishStatus { initial, loading, success, failure }

final class AddDishState extends Equatable {
  const AddDishState({this.status = AddDishStatus.initial, this.dish});

  final AddDishStatus status;
  final Dish? dish;

  AddDishState copyWith({
    AddDishStatus? status,
    Dish? dish,
  }) {
    return AddDishState(
      status: status ?? this.status,
      dish: dish ?? this.dish,
    );
  }

  @override
  List<Object?> get props => [status, dish];
}
