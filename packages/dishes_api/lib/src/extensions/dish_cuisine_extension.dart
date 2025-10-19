import '../../dishes_api.dart';

extension DishCuisineX on DishCuisine {
  String get name {
    final raw = toString().split('.').last;
    // Handle camelCase like "southAfrican" → "South African"
    final spaced = raw.replaceAllMapped(
      RegExp(r'([a-z])([A-Z])'),
      (m) => '${m[1]} ${m[2]}',
    );
    return '${spaced[0].toUpperCase()}${spaced.substring(1)}';
  }

  String get flagEmoji {
    return String.fromCharCodes(
      countryCode.codeUnits.map((c) => 0x1F1E6 - 65 + c),
    );
  }

  String get displayName => '$name $flagEmoji';
}
