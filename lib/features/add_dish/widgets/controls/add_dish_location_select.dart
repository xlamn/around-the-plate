import 'package:around_the_plate/extensions/extensions.dart';
import 'package:dishes_api/dishes_api.dart';
import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:permission_handler/permission_handler.dart';

class AddDishLocationSelect extends StatefulWidget {
  final FSelectController<DishLocation> controller;

  const AddDishLocationSelect({super.key, required this.controller});

  @override
  State<AddDishLocationSelect> createState() => _AddDishLocationSelectState();
}

class _AddDishLocationSelectState extends State<AddDishLocationSelect> {
  final List<DishLocation> _locations = [];
  bool _isLoading = true;

  @override
  void initState() {
    _initLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isLoading && _locations.isEmpty) {
      return const SizedBox.shrink();
    }

    return FSelect<DishLocation>.rich(
      controller: widget.controller,
      label: const Text('Location'),
      hint: _isLoading ? 'Loading locations...' : 'Select location',
      clearable: true,
      format: (c) => c.placeName?.toCapitalized() ?? '',
      children: [
        for (final location in _locations)
          FSelectItem(
            title: Text(location.placeName?.toCapitalized() ?? ''),
            value: location,
          ),
      ],
    );
  }

  Future<void> _initLocation() async {
    try {
      final position = await _getCurrentPosition();
      if (position == null) return;

      final locations = await _getLocationsFromCoordinates(
        position.latitude,
        position.longitude,
      );

      setState(() {
        _locations.addAll(locations);
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      debugPrint('Error getting location: $e');
    }
  }

  Future<Position?> _getCurrentPosition() async {
    final status = await Permission.location.request();
    if (status.isGranted) {
      return Geolocator.getCurrentPosition();
    } else {
      return null;
    }
  }

  Future<List<DishLocation>> _getLocationsFromCoordinates(
    double latitude,
    double longitude,
  ) async {
    final placemarks = await placemarkFromCoordinates(
      latitude,
      longitude,
    );

    if (placemarks.isEmpty) return [];

    return placemarks.map((place) {
      final placeName = [
        place.name,
        place.locality,
        place.administrativeArea,
        place.country,
      ].where((e) => e != null && e.isNotEmpty).join(', ');

      return DishLocation(
        latitude: latitude,
        longitude: longitude,
        placeName: placeName,
      );
    }).toList();
  }
}
