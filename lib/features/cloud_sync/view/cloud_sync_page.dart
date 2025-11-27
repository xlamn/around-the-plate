import 'dart:developer';

import 'package:app_theme/app_theme.dart';
import 'package:cloud_sync_api/cloud_sync_api.dart';
import 'package:dishes_repository/dishes_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_drive_sync_api/google_drive_sync_api.dart';

class CloudSyncPage extends StatefulWidget {
  const CloudSyncPage({super.key});

  @override
  State<CloudSyncPage> createState() => _CloudSyncPageState();
}

class _CloudSyncPageState extends State<CloudSyncPage> {
  late final CloudSyncService cloudSyncService;
  bool isEnabled = false;

  @override
  void initState() {
    super.initState();
    cloudSyncService = CloudSyncService(
      repository: context.read<DishesRepository>(),
      cloudApi: GoogleDriveSyncApi.instance,
    );
    isEnabled = cloudSyncService.isSignedIn();
  }

  //TODO: Add loading behaviour, text indicating last sync time and information text about down/uploading

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(FIcons.arrowLeft),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const FHeader(title: Text('Cloud Sync')),
          Padding(
            padding: const EdgeInsets.all(AppSizes.spacing16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Google Drive Login',
                        style: context.theme.typography.base,
                      ),
                    ],
                  ),
                ),
                FSwitch(
                  value: isEnabled,
                  onChange: (value) async {
                    if (!isEnabled) {
                      try {
                        await cloudSyncService.login();
                        setState(() => isEnabled = value);
                      } catch (e) {
                        log('Error initializing Google Drive: $e');
                      }
                    } else {
                      await cloudSyncService.logout();
                      setState(() => isEnabled = value);
                    }
                  },
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppSizes.spacing16),
            child: FButton(
              onPress: isEnabled
                  ? () async {
                      await cloudSyncService.sync();
                    }
                  : null,
              child: Text('Sync Now'),
            ),
          ),
        ],
      ),
    );
  }
}
