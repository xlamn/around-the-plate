enum DishesSortOption {
  defaultOrder('Default'),
  date('Date'),
  rating('Rating'),
  lastModified('Last Modified');

  final String label;

  const DishesSortOption(this.label);
}
