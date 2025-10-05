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
  DishLocation? _location;
  bool _isLoading = true;

  @override
  void initState() {
    _initLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isLoading && _location == null) {
      return const SizedBox.shrink();
    }

    return FSelect<DishLocation>.rich(
      controller: widget.controller,
      label: const Text('Location'),
      hint: _isLoading ? 'Loading location...' : 'Select location',
      clearable: true,
      format: (c) => c.placeName?.toCapitalized() ?? '',
      children: [
        if (_location != null)
          FSelectItem(
            title: Text(_location!.placeName?.toCapitalized() ?? ''),
            value: _location!,
          ),
      ],
    );
  }

  Future<void> _initLocation() async {
    try {
      final position = await _getCurrentPosition();
      if (position == null) return;

      final placeName = await _getPlaceFromCoordinates(position);
      setState(() {
        _location = DishLocation(
          latitude: position.latitude,
          longitude: position.longitude,
          placeName: placeName,
        );
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

  Future<String> _getPlaceFromCoordinates(Position position) async {
    final placemarks = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );

    if (placemarks.isEmpty) return 'Unknown location';

    final place = placemarks.first;
    return [
      place.locality,
      place.administrativeArea,
      place.country,
    ].where((e) => e != null && e.isNotEmpty).join(', ');
  }
}
