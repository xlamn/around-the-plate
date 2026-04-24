import 'package:app_theme/app_theme.dart';
import 'package:dishes_repository/dishes_repository.dart';
import 'package:flutter/material.dart';

class CountryMapDetailsDialog extends StatelessWidget {
  final String country;
  final String flagEmoji;
  final List<Dish> dishes;

  const CountryMapDetailsDialog({
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
        padding: const EdgeInsets.symmetric(vertical: AppSizes.spacing16),
        child: Text(
          'You have enjoyed ${dishes.length} dish(es) from $country so far!',
        ),
      ),
      actions: [
        FButton(
          variant: FButtonVariant.primary,
          onPress: () => Navigator.of(context).pop(),
          child: const Text('OK'),
        ),
      ],
    );
  }
}
