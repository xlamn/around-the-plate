import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:equatable/equatable.dart';

part 'onboarding_camera_state.dart';

class OnboardingCameraCubit extends Cubit<OnboardingCameraState> {
  OnboardingCameraCubit() : super(const OnboardingCameraState());

  Future<void> requestCameraPermission() async {
    final status = await Permission.camera.request();
    if (status.isGranted) {
      emit(state.copyWith(status: CameraPermissionStatus.granted));
    } else if (status.isPermanentlyDenied) {
      emit(state.copyWith(status: CameraPermissionStatus.permanentlyDenied));
    } else {
      emit(state.copyWith(status: CameraPermissionStatus.denied));
    }
  }
}
