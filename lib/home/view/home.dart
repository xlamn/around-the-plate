import 'package:flutter/material.dart' hide Tab;
import 'package:flutter/widgets.dart';
import 'package:forui/forui.dart';

import '../../features/dishes_overview/view/dishes_overview_page.dart';
import '../../features/map_overview/view/map_overview_page.dart';
import '../../features/settings_overview/view/settings_overview_page.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int index = 0;
  late final List<FHeader> headers;
  late final List<Widget> contents;

  @override
  void initState() {
    super.initState();

    headers = [
      const FHeader(title: Text('Home')),
      const FHeader(title: Text('Map')),
      FHeader(
        title: const Text('Settings'),
        suffixes: [FHeaderAction(icon: Icon(FIcons.ellipsis), onPress: () {})],
      ),
    ];

    contents = [
      DishesOverviewPage(),
      MapOverviewPage(),
      SettingsOverviewPage(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return FScaffold(
      header: headers[index],
      footer: FBottomNavigationBar(
        index: index,
        onChange: (index) => setState(() => this.index = index),
        children: const [
          FBottomNavigationBarItem(
            icon: Icon(FIcons.house),
            label: Text('Home'),
          ),
          FBottomNavigationBarItem(
            icon: Icon(FIcons.map),
            label: Text('Map'),
          ),
          FBottomNavigationBarItem(
            icon: Icon(FIcons.settings),
            label: Text('Settings'),
          ),
        ],
      ),
      child: IndexedStack(
        index: index,
        children: contents,
      ),
    );
  }
}
