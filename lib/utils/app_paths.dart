import 'package:path_provider/path_provider.dart';

/// A utility class to manage application paths. Provides synchronous access.
class AppPaths {
  static late final String documentsDir;

  static Future<void> init() async {
    final dir = await getApplicationDocumentsDirectory();
    documentsDir = dir.path;
  }

  static String imagePath(String relativePath) => '$documentsDir/$relativePath';
}
