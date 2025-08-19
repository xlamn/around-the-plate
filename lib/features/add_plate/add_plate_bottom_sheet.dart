import 'dart:io';

import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

const countries = [
  'Vietnam',
  'United States',
  'Japan',
  'South Korea',
  'France',
  'Germany',
  'Italy',
  'Spain',
  'United Kingdom',
];

class AddPlateScreen extends StatelessWidget {
  final String imagePath;

  const AddPlateScreen({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                FButton(
                  onPress: () {},
                  child: const Text("Save"),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: SizedBox(
                    height: 100,
                    width: 100,
                    child: Image.file(File(imagePath)),
                  ),
                ),
                Expanded(
                  child: FTextField(
                    label: const Text('Plate Name'),
                    hint: 'Spaghetti Carbonara',
                    maxLines: 1,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            FSelect<String>(
              label: const Text('Plate Origin'),
              hint: 'Select a country',
              format: (s) => s,
              children: [
                for (final country in countries) FSelectItem(country, country),
              ],
            ),
            const SizedBox(height: 16),
            ClearableDateField(),
            const SizedBox(height: 16),
            FSlider(
              label: const Text('Rating'),
              layout: FLayout.ltr,
              tooltipBuilder: (style, value) {
                final hex = (value * 100).round() / 10;
                return Text('$hex');
              },
              controller: FContinuousSliderController(
                selection: FSliderSelection(max: 0.5), // initial value
              ),
              marks: const [
                FSliderMark(value: 0.0, label: Text('0')),
                FSliderMark(value: 0.1, label: Text('1')),
                FSliderMark(value: 0.2, label: Text('2')),
                FSliderMark(value: 0.3, label: Text('3')),
                FSliderMark(value: 0.4, label: Text('4')),
                FSliderMark(value: 0.5, label: Text('5')),
                FSliderMark(value: 0.6, label: Text('6')),
                FSliderMark(value: 0.7, label: Text('7')),
                FSliderMark(value: 0.8, label: Text('8')),
                FSliderMark(value: 0.9, label: Text('9')),
                FSliderMark(value: 1.0, label: Text('10')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ClearableDateField extends StatefulWidget {
  @override
  State<ClearableDateField> createState() => _State();
}

class _State extends State<ClearableDateField>
    with SingleTickerProviderStateMixin {
  late final FDateFieldController _controller = FDateFieldController(
    vsync: this,
    initialDate: DateTime.now(),
  );

  @override
  Widget build(BuildContext context) => FDateField(
    controller: _controller,
    label: const Text('Date'),
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
