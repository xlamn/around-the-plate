part of 'cloud_sync_cubit.dart';

class CloudSyncState {
  final bool isSyncing;
  final DateTime? lastSync;
  final bool isSignedIn;

  CloudSyncState({
    this.isSyncing = false,
    this.lastSync,
    this.isSignedIn = false,
  });

  CloudSyncState copyWith({
    bool? isSyncing,
    DateTime? lastSync,
    bool? isSignedIn,
  }) {
    return CloudSyncState(
      isSyncing: isSyncing ?? this.isSyncing,
      lastSync: lastSync ?? this.lastSync,
      isSignedIn: isSignedIn ?? this.isSignedIn,
    );
  }
}
