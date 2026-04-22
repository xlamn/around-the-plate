import 'package:app_theme/app_theme.dart';
import 'package:cloud_sync_api/cloud_sync_api.dart';
import 'package:directory_image_storage_api/directory_image_storage_api.dart';
import 'package:dishes_repository/dishes_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_drive_sync_api/google_drive_sync_api.dart';

import '../cubit/cloud_sync_cubit.dart';

class CloudSyncPage extends StatelessWidget {
  const CloudSyncPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CloudSyncCubit(
        cloudSyncService: CloudSyncService(
          repository: context.read<DishesRepository>(),
          cloudApi: GoogleDriveSyncApi.instance,
          imageStorageDirectory: DirectoryImageStorageApi.instance.directory,
        ),
      ),
      child: const CloudSyncView(),
    );
  }
}

class CloudSyncView extends StatelessWidget {
  const CloudSyncView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CloudSyncCubit, CloudSyncState>(
      builder: (context, state) {
        final cubit = context.read<CloudSyncCubit>();
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(FIcons.arrowLeft),
            ),
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const FHeader(title: Text('Cloud Sync')),
              Padding(
                padding: const EdgeInsets.all(AppSizes.spacing16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Google Drive Login',
                      style: context.theme.typography.sm,
                    ),
                    FSwitch(
                      value: state.isSignedIn,
                      onChange: (enabled) async {
                        if (enabled) {
                          await cubit.login();
                        } else {
                          await cubit.logout();
                        }
                      },
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(AppSizes.spacing16),
                child: Column(
                  spacing: AppSizes.spacing8,
                  children: [
                    FButton(
                      onPress: state.isSignedIn && !state.isSyncing
                          ? () => cubit.sync()
                          : null,
                      child: state.isSyncing
                          ? const SizedBox(
                              height: AppSizes.iconS,
                              width: AppSizes.iconS,
                              child: CircularProgressIndicator.adaptive(),
                            )
                          : const Text('Sync Now'),
                    ),
                    Text(
                      'Your dishes will be uploaded to your Cloud. If you do not have any dishes, the app will download your dishes instead.',
                      textAlign: TextAlign.center,
                      style: context.theme.typography.sm.copyWith(
                        color: context.theme.colors.mutedForeground,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              if (state.lastSync != null)
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: AppSizes.spacing8,
                    ),
                    child: Text(
                      'Last synced: ${state.lastSync?.toLocal()}',
                      style: context.theme.typography.sm.copyWith(
                        color: context.theme.colors.mutedForeground,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
