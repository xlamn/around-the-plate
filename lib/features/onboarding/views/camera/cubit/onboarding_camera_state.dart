import 'package:equatable/equatable.dart';

enum CameraPermissionStatus { initial, granted, denied, permanentlyDenied }

class OnboardingCameraState extends Equatable {
  final CameraPermissionStatus status;

  const OnboardingCameraState({this.status = CameraPermissionStatus.initial});

  OnboardingCameraState copyWith({CameraPermissionStatus? status}) {
    return OnboardingCameraState(
      status: status ?? this.status,
    );
  }

  @override
  List<Object> get props => [status];
}
