import 'package:equatable/equatable.dart';

enum MapControllerStatus { initial, loading, success, failure }

class MapControllerState extends Equatable {
  final MapControllerStatus? status;
  final bool isMapLoaded;

  const MapControllerState({
    this.status = MapControllerStatus.initial,
    this.isMapLoaded = false,
  });

  MapControllerState copyWith({
    MapControllerStatus? status,
    bool? isMapLoaded,
  }) {
    return MapControllerState(
      isMapLoaded: isMapLoaded ?? this.isMapLoaded,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [isMapLoaded, status];
}
