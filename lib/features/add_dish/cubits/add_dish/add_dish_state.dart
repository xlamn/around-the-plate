import 'package:equatable/equatable.dart';

import '../../../../models/dish.dart';

abstract class AddDishState extends Equatable {
  const AddDishState();

  @override
  List<Object> get props => [];
}

class AddDishInitial extends AddDishState {}

class AddDishLoading extends AddDishState {}

class AddDishSuccess extends AddDishState {
  final Dish dish;

  const AddDishSuccess({required this.dish});

  @override
  List<Object> get props => [dish];
}

class AddDishError extends AddDishState {
  final String message;

  const AddDishError(this.message);

  @override
  List<Object> get props => [message];
}
