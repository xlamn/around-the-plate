import 'dart:developer';

import 'package:app_theme/app_theme.dart';
import 'package:cloud_sync_api/cloud_sync_api.dart';
import 'package:flutter/material.dart';

class CloudSyncPage extends StatefulWidget {
  final CloudSyncService cloudSyncService;

  const CloudSyncPage({super.key, required this.cloudSyncService});

  @override
  State<CloudSyncPage> createState() => _CloudSyncPageState();
}

class _CloudSyncPageState extends State<CloudSyncPage> {
  bool isEnabled = false;

  @override
  void initState() {
    super.initState();
    _checkSignInStatus();
  }

  Future<void> _checkSignInStatus() async {
    final signedIn = await widget.cloudSyncService.isSignedIn();
    setState(() {
      isEnabled = signedIn;
    });
  }

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
                        await widget.cloudSyncService.login();
                        setState(() => isEnabled = value);
                      } catch (e) {
                        log('Error initializing Google Drive: $e');
                      }
                    } else {
                      await widget.cloudSyncService.logout();
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
                      await widget.cloudSyncService.sync();
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
