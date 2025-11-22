import 'package:app_theme/app_theme.dart';
import 'package:flutter/material.dart';

import '../../../services/url_launcher_service.dart';
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
          FHeader(
            title: const Text('Settings'),
          ),
          Padding(
            padding: const EdgeInsets.all(AppSizes.spacing16),
            child: FTileGroup(
              label: const Text('General'),
              children: [
                FTile(
                  prefix: Icon(FIcons.palette),
                  title: const Text('Theme'),
                  suffix: Icon(FIcons.chevronRight),
                  onPress: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ThemeSelectionPage(),
                      ),
                    );
                  },
                ),
                FTile(
                  prefix: Icon(FIcons.refreshCcwDot),
                  title: const Text('Synchronization'),
                  suffix: Icon(FIcons.chevronRight),
                  onPress: () {},
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
                  prefix: Icon(FIcons.mail),
                  title: const Text('Contact Developer'),
                  suffix: Icon(FIcons.squareArrowOutUpRight),
                  onPress: () async => await _urlLauncherService.openEmail(
                    subject: 'Around the Plate - Request',
                  ),
                ),
                FTile(
                  prefix: Icon(FIcons.cookie),
                  title: const Text('Buy a cookie'),
                  suffix: Icon(FIcons.squareArrowOutUpRight),
                  onPress: () async => await _urlLauncherService.openUrl(
                    'https://paypal.me/xlamn',
                  ),
                ),
                FTile(
                  prefix: Icon(FIcons.star),
                  title: const Text('Rate App'),
                  suffix: Icon(FIcons.squareArrowOutUpRight),
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
                  prefix: Icon(FIcons.fileSpreadsheet),
                  title: const Text('Imprint'),
                  suffix: Icon(FIcons.chevronRight),
                  onPress: () async => await _urlLauncherService.openUrl(
                    'https://www.tlnguyen.fyi/works/aroundtheplate/imprint',
                  ),
                ),
                FTile(
                  prefix: Icon(FIcons.handshake),
                  title: const Text('Privacy Policy'),
                  suffix: Icon(FIcons.chevronRight),
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
