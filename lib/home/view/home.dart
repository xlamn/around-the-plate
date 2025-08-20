import 'package:flutter/material.dart' hide Tab;
import 'package:flutter/widgets.dart';
import 'package:forui/forui.dart';

import '../../features/dishes_overview/view/dishes_overview_page.dart';
import '../../features/map_overview/view/map_overview_page.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int index = 0;

  @override
  Widget build(BuildContext context) => FScaffold(
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
    child: contents[index],
  );
}

final headers = [
  const FHeader(title: Text('Home')),
  const FHeader(title: Text('Map')),
  FHeader(
    title: const Text('Settings'),
    suffixes: [FHeaderAction(icon: Icon(FIcons.ellipsis), onPress: () {})],
  ),
];

final contents = [
  DishesOverviewPage(),
  MapOverviewPage(),
  Column(
    children: [
      const SizedBox(height: 5),
      FCard(
        title: const Text('Account'),
        subtitle: const Text(
          'Make changes to your account here. Click save when you are done.',
        ),
        child: Column(
          children: [
            const FTextField(label: Text('Name'), hint: 'John Renalo'),
            const SizedBox(height: 10),
            const FTextField(label: Text('Email'), hint: 'john@doe.com'),
            const SizedBox(height: 16),
            FButton(onPress: () {}, child: const Text('Save')),
          ],
        ),
      ),
    ],
  ),
];
