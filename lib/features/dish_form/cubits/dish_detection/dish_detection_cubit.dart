import 'package:dish_detection_api/dish_detection_api.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'dish_detection_state.dart';

class DishDetectionCubit extends Cubit<DishDetectionState> {
  final DishDetectionApi dishDetectionApi;

  DishDetectionCubit({
    required String? imagePath,
    required this.dishDetectionApi,
  }) : super(const DishDetectionState()) {
    if (imagePath != null) _detect(imagePath);
  }

  Future<void> _detect(String imagePath) async {
    emit(state.copyWith(status: DishDetectionStatus.detecting));
    final name = await dishDetectionApi.detectDish(imagePath);
    emit(
      name != null
          ? state.copyWith(status: DishDetectionStatus.detected, name: name)
          : state.copyWith(status: DishDetectionStatus.notFood),
    );
  }
}
