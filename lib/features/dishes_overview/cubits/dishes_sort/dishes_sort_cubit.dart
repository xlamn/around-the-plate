// lib/features/dishes_overview/cubits/dishes_sort/dishes_sort_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/dishes_sort_option.dart';

class DishesSortCubit extends Cubit<DishesSortOption> {
  DishesSortCubit() : super(DishesSortOption.defaultOrder);

  void changeSort(DishesSortOption option) => emit(option);
}
