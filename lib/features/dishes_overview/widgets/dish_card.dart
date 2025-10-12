import 'dart:io';

import 'package:dishes_repository/dishes_repository.dart';
import 'package:flutter/material.dart';

import '../../dishes_overview/widgets/dish_card_rating.dart';
import '../../dish_details/view/dish_details_page.dart';

class DishCard extends StatelessWidget {
  final Dish dish;

  const DishCard({super.key, required this.dish});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _openDetailsPage(context),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 10,
              offset: const Offset(8, 8),
            ),
          ],
        ),
        margin: const EdgeInsets.symmetric(horizontal: 16.0),
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SizedBox(
              width: 80,
              height: 80,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.file(
                  File(dish.imagePath),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Expanded(
              child: Column(
                spacing: 4.0,
                children: [
                  Text(
                    dish.name,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (dish.origin != null)
                    Text(
                      dish.origin!,
                      style:
                          Theme.of(
                            context,
                          ).textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w300,
                          ),
                    ),
                ],
              ),
            ),
            SizedBox(
              width: 80,
              child: Center(
                child: DishCardRating(
                  rating: dish.rating,
                ),
              ),
            ),
          ],
        ),
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
