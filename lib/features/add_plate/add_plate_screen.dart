import 'dart:io';

import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

class AddPlateScreen extends StatelessWidget {
  final String imagePath;

  const AddPlateScreen({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Plate'),
      ),
      body: Image.file(File(imagePath)),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: FButton(
          onPress: () {
            Navigator.of(context).pop();
          },
          child: const Text('Add Plate'),
        ),
      ),
    );
  }
}
