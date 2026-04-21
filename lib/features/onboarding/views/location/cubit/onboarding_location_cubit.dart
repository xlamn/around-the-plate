import 'package:around_the_plate/services/location_service.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';

part 'onboarding_location_state.dart';

class OnboardingLocationCubit extends Cubit<OnboardingLocationState> {
  final LocationService _service;

  OnboardingLocationCubit({required LocationService service})
    : _service = service,
      super(const OnboardingLocationState());

  Future<void> requestLocationPermission() async {
    final status = await _service.requestPermission();
    if (status.isGranted) {
      emit(state.copyWith(status: LocationPermissionStatus.granted));
    } else if (status.isPermanentlyDenied) {
      emit(state.copyWith(status: LocationPermissionStatus.permanentlyDenied));
    } else {
      emit(state.copyWith(status: LocationPermissionStatus.denied));
    }
  }
}
