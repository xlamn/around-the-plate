import 'package:cloud_sync_api/cloud_sync_api.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

part 'cloud_sync_state.dart';

class CloudSyncCubit extends HydratedCubit<CloudSyncState> {
  CloudSyncCubit({required this.cloudSyncService}) : super(CloudSyncState());

  static const _lastSyncKey = 'lastSync';

  final CloudSyncService cloudSyncService;

  Future<void> login() async {
    await cloudSyncService.login();
    emit(state.copyWith(isSignedIn: true));
  }

  Future<void> logout() async {
    await cloudSyncService.logout();
    emit(state.copyWith(isSignedIn: false));
  }

  Future<void> sync() async {
    emit(state.copyWith(isSyncing: true));
    await cloudSyncService.sync();
    emit(
      state.copyWith(
        isSyncing: false,
        lastSync: DateTime.now(),
      ),
    );
  }

  @override
  CloudSyncState? fromJson(Map<String, dynamic> json) {
    return CloudSyncState(
      isSignedIn: cloudSyncService.isSignedIn(),
      lastSync: json[_lastSyncKey] != null
          ? DateTime.tryParse(json[_lastSyncKey])
          : null,
    );
  }

  @override
  Map<String, dynamic>? toJson(CloudSyncState state) {
    return {
      _lastSyncKey: state.lastSync?.toIso8601String(),
    };
  }
}
