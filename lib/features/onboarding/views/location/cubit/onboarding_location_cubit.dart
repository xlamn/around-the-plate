import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'onboarding_location_state.dart';

class OnboardingLocationCubit extends Cubit<OnboardingLocationState> {
  OnboardingLocationCubit() : super(const OnboardingLocationState());

  Future<void> requestPermission() async {
    final status = await Permission.location.request();
    if (status.isGranted) {
      emit(state.copyWith(status: LocationPermissionStatus.granted));
    } else if (status.isPermanentlyDenied) {
      emit(state.copyWith(status: LocationPermissionStatus.permanentlyDenied));
    } else {
      emit(state.copyWith(status: LocationPermissionStatus.denied));
    }
  }
}
