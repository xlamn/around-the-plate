import 'package:dishes_repository/dishes_repository.dart';
import 'package:flutter/widgets.dart';
import 'package:forui/forui.dart';

class DishCard extends StatelessWidget {
  final Dish dish;

  const DishCard({super.key, required this.dish});

  @override
  Widget build(BuildContext context) {
    return FCard(
      title: Text(dish.name),
      subtitle: const Text(
        'Make changes to your account here. Click save when you are done.',
      ),
    );
  }
}
