import 'dart:convert';

import 'package:dishes_api/dishes_api.dart';
import 'package:flutter/foundation.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:location_api/location_api.dart';

class MapboxLocationApi implements LocationApi {
  static MapboxLocationApi? _instance;

  static MapboxLocationApi get instance {
    assert(_instance != null, 'MapboxLocationApi.init() must be called first');
    return _instance!;
  }

  final String _accessToken;

  MapboxLocationApi._({required String accessToken}) : _accessToken = accessToken;

  static void init({required String accessToken}) {
    _instance = MapboxLocationApi._(accessToken: accessToken);
  }

  @override
  Future<DishLocation?> getCurrentLocation() async {
    try {
      final position = await Geolocator.getCurrentPosition();
      final placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      if (placemarks.isEmpty) return null;

      final place = placemarks.first;
      final placeName = [
        place.name,
        place.locality,
        place.administrativeArea,
        place.country,
      ].where((e) => e != null && e.isNotEmpty).join(', ');

      return DishLocation(
        latitude: position.latitude,
        longitude: position.longitude,
        placeName: placeName,
      );
    } catch (e) {
      debugPrint('Error getting current location: $e');
      return null;
    }
  }

  @override
  Future<List<DishLocation>> searchLocations(
    String query, {
    DishLocation? currentLocation,
  }) async {
    if (query.isEmpty) {
      return currentLocation != null ? [currentLocation] : [];
    }

    try {
      final uri = Uri.parse(
        'https://api.mapbox.com/search/geocode/v6/forward'
        '?q=${Uri.encodeComponent(query)}'
        '&limit=5'
        '&access_token=$_accessToken',
      );

      final response = await http.get(uri);
      if (response.statusCode != 200) return _fallback(query, currentLocation);

      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final features = (data['features'] as List<dynamic>?) ?? [];

      final results = features.map((feature) {
        final coords = feature['geometry']['coordinates'] as List<dynamic>;
        final properties = feature['properties'] as Map<String, dynamic>;
        final name = properties['full_address'] as String? ?? properties['name'] as String? ?? '';
        return DishLocation(
          latitude: (coords[1] as num).toDouble(),
          longitude: (coords[0] as num).toDouble(),
          placeName: name,
        );
      }).toList();

      if (currentLocation?.placeName?.toLowerCase().contains(query.toLowerCase()) == true) {
        return [currentLocation!, ...results];
      }

      return results;
    } catch (e) {
      debugPrint('Error searching locations: $e');
      return _fallback(query, currentLocation);
    }
  }

  List<DishLocation> _fallback(String query, DishLocation? currentLocation) {
    if (currentLocation?.placeName?.toLowerCase().contains(query.toLowerCase()) == true) {
      return [currentLocation!];
    }
    return [];
  }
}
