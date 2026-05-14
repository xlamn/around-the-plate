import 'package:trips_repository/trips_repository.dart';

import '../models/trips_sort_option.dart';

extension TripListSorting on List<Trip> {
  List<Trip> sortedBy(TripsSortOption option) {
    switch (option) {
      case TripsSortOption.name:
        sort((a, b) => a.name.compareTo(b.name));
        break;
      case TripsSortOption.createdDate:
        sort((a, b) => b.createdDate.compareTo(a.createdDate));
        break;
      case TripsSortOption.lastModified:
        sort((a, b) => b.lastModifiedDate.compareTo(a.lastModifiedDate));
        break;
      case TripsSortOption.defaultOrder:
        sort((a, b) => b.id.compareTo(a.id));
        break;
    }
    return this;
  }
}
