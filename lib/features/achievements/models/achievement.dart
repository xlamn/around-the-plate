class Achievement {
  final String id;
  final String name;
  final String description;
  final String badgeAsset;
  final bool isUnlocked;
  final double progress; // 0.0 to 1.0
  final String progressLabel; // e.g. "3 / 10"

  const Achievement({
    required this.id,
    required this.name,
    required this.description,
    required this.badgeAsset,
    required this.isUnlocked,
    required this.progress,
    required this.progressLabel,
  });
}
