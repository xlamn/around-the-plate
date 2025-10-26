import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

class SettingsOverviewPage extends StatelessWidget {
  const SettingsOverviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FHeader(
          title: const Text('Settings'),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: FTileGroup(
            label: const Text('General'),
            children: [
              FTile(
                prefix: Icon(FIcons.palette),
                title: const Text('Theme'),
                suffix: Icon(FIcons.chevronRight),
                onPress: () {},
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
          padding: const EdgeInsets.all(16.0),
          child: FTileGroup(
            label: const Text('Support'),
            children: [
              FTile(
                prefix: Icon(FIcons.mail),
                title: const Text('Contact Developer'),
                suffix: Icon(FIcons.squareArrowOutUpRight),
                onPress: () {},
              ),
              FTile(
                prefix: Icon(FIcons.cookie),
                title: const Text('Buy a cookie'),
                suffix: Icon(FIcons.squareArrowOutUpRight),
                onPress: () {},
              ),
              FTile(
                prefix: Icon(FIcons.star),
                title: const Text('Rate App'),
                suffix: Icon(FIcons.squareArrowOutUpRight),
                onPress: () {},
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: FTileGroup(
            label: const Text('Legal'),
            children: [
              FTile(
                prefix: Icon(FIcons.fileSpreadsheet),
                title: const Text('Imprint'),
                suffix: Icon(FIcons.chevronRight),
                onPress: () {},
              ),
              FTile(
                prefix: Icon(FIcons.handshake),
                title: const Text('Privacy Policy'),
                suffix: Icon(FIcons.chevronRight),
                onPress: () {},
              ),
            ],
          ),
        ),
      ],
    );
  }
}
