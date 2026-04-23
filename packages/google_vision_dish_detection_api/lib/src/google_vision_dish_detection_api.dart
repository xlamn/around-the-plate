import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dish_detection_api/dish_detection_api.dart';
import 'package:http/http.dart' as http;

class GoogleVisionDishDetectionApi implements DishDetectionApi {
  static const _visionApiUrl = 'https://vision.googleapis.com/v1/images:annotate';

  static GoogleVisionDishDetectionApi? _instance;

  static GoogleVisionDishDetectionApi get instance {
    assert(_instance != null, 'GoogleVisionDishDetectionApi.init() must be called first');
    return _instance!;
  }

  final String _apiKey;

  GoogleVisionDishDetectionApi._({required String apiKey}) : _apiKey = apiKey;

  static void init({required String apiKey}) {
    _instance = GoogleVisionDishDetectionApi._(apiKey: apiKey);
  }

  @override
  Future<String?> detectDish(String imagePath) async {
    try {
      final imageBytes = await File(imagePath).readAsBytes();
      final base64Image = base64Encode(imageBytes);

      final response = await http.post(
        Uri.parse('$_visionApiUrl?key=$_apiKey'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'requests': [
            {
              'image': {'content': base64Image},
              'features': [
                {'type': 'WEB_DETECTION', 'maxResults': 5},
                {'type': 'LABEL_DETECTION', 'maxResults': 10},
              ],
            },
          ],
        }),
      );

      if (response.statusCode != 200) {
        log('Vision API error: ${response.body}', name: '$GoogleVisionDishDetectionApi');
        return null;
      }

      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final response0 = data['responses']?[0];

      final labels = (response0?['labelAnnotations'] as List?) ?? [];
      final isFood = labels.any(
        (l) => _foodLabels.contains(
          (l['description'] as String?)?.toLowerCase(),
        ),
      );
      if (!isFood) return null;

      final webDetection = response0?['webDetection'];

      final bestGuessLabels = webDetection?['bestGuessLabels'] as List?;
      final bestGuess = bestGuessLabels?.firstOrNull?['label'] as String?;
      if (bestGuess != null && bestGuess.isNotEmpty) {
        return _toTitleCase(bestGuess);
      }

      final webEntities = webDetection?['webEntities'] as List?;
      final topEntity = webEntities
          ?.where((e) => e['description'] != null && (e['score'] ?? 0) > 0.7)
          .firstOrNull;
      return topEntity?['description'] as String?;
    } catch (_) {
      return null;
    }
  }

  static const _foodLabels = {
    'food', 'dish', 'cuisine', 'ingredient', 'recipe', 'meal', 'snack',
    'breakfast', 'lunch', 'dinner', 'dessert', 'appetizer', 'baked goods',
    'fast food', 'comfort food', 'street food', 'seafood', 'meat', 'vegetable',
    'fruit', 'salad', 'soup', 'pasta', 'bread', 'pizza', 'burger', 'sushi',
    'noodle', 'rice', 'sandwich', 'taco', 'stew', 'curry', 'barbecue',
  };

  String _toTitleCase(String s) =>
      s.split(' ').map((w) => w.isEmpty ? w : '${w[0].toUpperCase()}${w.substring(1)}').join(' ');
}
