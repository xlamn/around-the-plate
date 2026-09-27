import 'package:app_theme/app_theme.dart';
import 'package:flutter/material.dart';

import '../../../services/url_launcher_service.dart';
import '../../cloud_sync/cloud_sync.dart';
import '../../theme_selection/theme_selection.dart';

class SettingsOverviewPage extends StatelessWidget {
  final UrlLauncherService _urlLauncherService;

  const SettingsOverviewPage({
    super.key,
    UrlLauncherService? urlLauncherService,
  }) : _urlLauncherService = urlLauncherService ?? const UrlLauncherService();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const FHeader(
            title: Text('Settings'),
          ),
          Padding(
            padding: const EdgeInsets.all(AppSizes.spacing16),
            child: FTileGroup(
              label: const Text('General'),
              children: [
                FTile(
                  prefix: const Icon(FLucideIcons.palette),
                  title: const Text('Theme'),
                  suffix: const Icon(FLucideIcons.chevronRight),
                  onPress: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const ThemeSelectionPage(),
                      ),
                    );
                  },
                ),
                if (Theme.of(context).platform == TargetPlatform.android)
                  FTile(
                    prefix: const Icon(FLucideIcons.refreshCcwDot),
                    title: const Text('Synchronization'),
                    suffix: const Icon(FLucideIcons.chevronRight),
                    onPress: () async {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const CloudSyncPage(),
                        ),
                      );
                    },
                  ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppSizes.spacing16),
            child: FTileGroup(
              label: const Text('Support'),
              children: [
                FTile(
                  prefix: const Icon(FLucideIcons.mail),
                  title: const Text('Contact Developer'),
                  suffix: const Icon(FLucideIcons.squareArrowOutUpRight),
                  onPress: () async => await _urlLauncherService.openEmail(
                    subject: 'Around the Plate - Request',
                  ),
                ),
                FTile(
                  prefix: const Icon(FLucideIcons.cookie),
                  title: const Text('Buy a cookie'),
                  suffix: const Icon(FLucideIcons.squareArrowOutUpRight),
                  onPress: () async => await _urlLauncherService.openUrl(
                    'https://paypal.me/xlamn',
                  ),
                ),
                FTile(
                  prefix: const Icon(FLucideIcons.star),
                  title: const Text('Rate App'),
                  suffix: const Icon(FLucideIcons.squareArrowOutUpRight),
                  onPress: null,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppSizes.spacing16),
            child: FTileGroup(
              label: const Text('Legal'),
              children: [
                FTile(
                  prefix: const Icon(FLucideIcons.fileSpreadsheet),
                  title: const Text('Imprint'),
                  suffix: const Icon(FLucideIcons.chevronRight),
                  onPress: () async => await _urlLauncherService.openUrl(
                    'https://www.tlnguyen.fyi/works/aroundtheplate/imprint',
                  ),
                ),
                FTile(
                  prefix: const Icon(FLucideIcons.handshake),
                  title: const Text('Privacy Policy'),
                  suffix: const Icon(FLucideIcons.chevronRight),
                  onPress: () async => await _urlLauncherService.openUrl(
                    'https://www.tlnguyen.fyi/works/aroundtheplate/privacy_policy',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
