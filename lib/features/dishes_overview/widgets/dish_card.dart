import 'package:dishes_repository/dishes_repository.dart';
import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

import '../../dish_details/view/dish_details_page.dart';

class DishCard extends StatelessWidget {
  final Dish dish;

  const DishCard({super.key, required this.dish});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _openDetailsPage(context),
      child: FCard(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(dish.name),
            Text(
              '${dish.rating * 10}',
            ),
          ],
        ),
        subtitle: dish.origin != null ? Text(dish.origin!) : null,
      ),
    );
  }

  Future<String?> _openDetailsPage(BuildContext context) async {
    return Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => DishDetailsPage(
          dish: dish,
        ),
      ),
    );
  }
}
