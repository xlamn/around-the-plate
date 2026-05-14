import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/trips_sort_option.dart';

class TripsSortCubit extends Cubit<TripsSortOption> {
  TripsSortCubit() : super(TripsSortOption.defaultOrder);

  void changeSort(TripsSortOption option) => emit(option);
}
