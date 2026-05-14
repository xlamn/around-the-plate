enum TripsSortOption {
  defaultOrder('Default'),
  name('Name'),
  createdDate('Date'),
  lastModified('Last Modified');

  final String label;

  const TripsSortOption(this.label);
}
