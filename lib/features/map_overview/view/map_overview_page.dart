import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

class MapOverviewPage extends StatelessWidget {
  const MapOverviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const FHeader(title: Text('Map')),
        const Placeholder(),
      ],
    );
  }
}
