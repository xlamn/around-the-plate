import 'package:equatable/equatable.dart';

enum LocationPermissionStatus { initial, granted, denied, permanentlyDenied }

class OnboardingLocationState extends Equatable {
  final LocationPermissionStatus status;

  const OnboardingLocationState({
    this.status = LocationPermissionStatus.initial,
  });

  OnboardingLocationState copyWith({LocationPermissionStatus? status}) {
    return OnboardingLocationState(
      status: status ?? this.status,
    );
  }

  @override
  List<Object> get props => [status];
}
