import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

class AddDishRatingSlider extends StatelessWidget {
  final FSliderController controller;

  const AddDishRatingSlider({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return FSlider(
      label: const Text('Rating'),
      layout: FLayout.ltr,
      tooltipBuilder: (style, value) {
        final hex = (value * 100).round() / 10;
        return Text('$hex');
      },
      controller: controller,
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
    );
  }
}
