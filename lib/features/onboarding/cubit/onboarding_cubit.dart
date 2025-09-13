import 'package:flutter_bloc/flutter_bloc.dart';

import 'onboarding_state.dart';

class DishesOverviewCubit extends Cubit<OnboardingState> {
  DishesOverviewCubit() : super(OnboardingState());
  bool _hasRequested = false;

  checkPermissions() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _hasRequested = prefs.getBool('hasRequestedPermissions') ?? false;

    if (!_hasRequested) {
      emit(state.copyWith(status: OnboardingStatus.initial));
    }
    emit(state.copyWith(status: OnboardingStatus.success));
  }

  requestPermission() async {
    await Permission.location.request();
  }
}
