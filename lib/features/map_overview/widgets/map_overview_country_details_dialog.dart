import 'package:dishes_repository/dishes_repository.dart';
import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

class MapOverviewCountryDetailsDialog extends StatelessWidget {
  final String country;
  final List<Dish> dishes;

  const MapOverviewCountryDetailsDialog({
    super.key,
    required this.country,
    required this.dishes,
  });

  @override
  Widget build(BuildContext context) {
    return FDialog(
      title: Text(country),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Text(
          'You have enjoyed ${dishes.length} dishes from $country so far!',
        ),
      ),
      actions: [
        FButton(
          style: FButtonStyle.primary(),
          onPress: () => Navigator.of(context).pop(),
          child: const Text('OK'),
        ),
      ],
    );
  }
}
