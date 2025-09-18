class Env {
  static String get googleVisionApiKey =>
      const String.fromEnvironment('GOOGLE_VISION_API_KEY');
  static String get mapboxApiKey =>
      const String.fromEnvironment('MAPBOX_API_KEY');
}
