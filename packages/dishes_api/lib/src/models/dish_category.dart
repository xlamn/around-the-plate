enum DishCategory {
  appetizer('Appetizer'),
  dessert('Dessert'),
  drink('Drink'),
  meal('Meal'),
  snack('Snack');

  const DishCategory(this.label);
  final String label;
}
