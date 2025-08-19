import 'package:around_the_plate/pages/home/home.dart';
import 'package:around_the_plate/pages/map/world_map.dart';
import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = FThemes.slate.light;

    return MaterialApp(
      // TODO: replace with your application's supported locales.
      supportedLocales: FLocalizations.supportedLocales,
      // TODO: add your application's localizations delegates.
      localizationsDelegates: const [...FLocalizations.localizationsDelegates],
      builder: (_, child) => FTheme(data: theme, child: child!),
      theme: theme.toApproximateMaterialTheme(),
      home: _Application(),
    );
  }
}

class _Application extends StatefulWidget {
  const _Application();

  @override
  State<_Application> createState() => _ApplicationState();
}

class _ApplicationState extends State<_Application> {
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
  Home(),
  WorldMap(),
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
