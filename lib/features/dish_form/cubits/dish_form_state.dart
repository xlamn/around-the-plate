part of 'dish_form_cubit.dart';

enum DishFormStatus { initial, loading, success, failure }

final class DishFormState extends Equatable {
  const DishFormState({this.status = DishFormStatus.initial, this.dish});

  final DishFormStatus status;
  final Dish? dish;

  DishFormState copyWith({
    DishFormStatus? status,
    Dish? dish,
  }) {
    return DishFormState(
      status: status ?? this.status,
      dish: dish ?? this.dish,
    );
  }

  @override
  List<Object?> get props => [status, dish];
}
