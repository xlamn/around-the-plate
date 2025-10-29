import 'package:dishes_repository/dishes_repository.dart';

import '../models/dishes_sort_option.dart';

extension DishListSorting on List<Dish> {
  List<Dish> sortedBy(DishesSortOption option) {
    switch (option) {
      case DishesSortOption.date:
        sort(
          (a, b) => b.date?.compareTo(a.date ?? DateTime.utc(1989)) ?? -1,
        );
        break;
      case DishesSortOption.rating:
        sort((a, b) => b.rating.compareTo(a.rating));
        break;
      case DishesSortOption.lastModified:
        sort((a, b) => b.lastModifiedDate.compareTo(a.lastModifiedDate));
        break;
      case DishesSortOption.defaultOrder:
        sort((a, b) => b.id.compareTo(a.id));
        break;
    }
    return this;
  }
}
