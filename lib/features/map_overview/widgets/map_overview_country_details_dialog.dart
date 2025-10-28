import 'package:app_theme/app_theme.dart';
import 'package:dishes_repository/dishes_repository.dart';
import 'package:flutter/material.dart';

class MapOverviewCountryDetailsDialog extends StatelessWidget {
  final String country;
  final String flagEmoji;
  final List<Dish> dishes;

  const MapOverviewCountryDetailsDialog({
    super.key,
    required this.country,
    required this.flagEmoji,
    required this.dishes,
  });

  @override
  Widget build(BuildContext context) {
    return FDialog(
      title: Text('$country $flagEmoji'),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Text(
          'You have enjoyed ${dishes.length} dish(es) from $country so far!',
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
