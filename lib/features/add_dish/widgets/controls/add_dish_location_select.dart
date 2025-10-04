import 'package:around_the_plate/extensions/extensions.dart';
import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class AddDishLocationSelect extends StatefulWidget {
  final FSelectController<String> controller;

  const AddDishLocationSelect({super.key, required this.controller});

  @override
  State<AddDishLocationSelect> createState() => _AddDishLocationSelectState();
}

class _AddDishLocationSelectState extends State<AddDishLocationSelect> {
  Position? position;
  String? location;

  @override
  void initState() {
    _loadLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FSelect<String>.rich(
      controller: widget.controller,
      label: const Text('Location'),
      hint: location ?? 'Select a location',
      clearable: true,
      format: (c) => c.toCapitalized(),
      children: [
        if (location != null)
          FSelectItem(
            title: Text(location!.toCapitalized()),
            value: location!,
          ),
      ],
    );
  }

  Future<void> _loadLocation() async {
    try {
      final pos = await Geolocator.getCurrentPosition();
      final place = await _getPlaceFromCoordinates(pos);

      if (mounted) {
        setState(() {
          position = pos;
          location = place;
          widget.controller.value = place;
        });
      }
    } catch (e) {
      debugPrint('Error getting location: $e');
    }
  }

  Future<String> _getPlaceFromCoordinates(Position position) async {
    final placemarks = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );

    if (placemarks.isNotEmpty) {
      final place = placemarks.first;
      return '${place.locality}, ${place.administrativeArea}, ${place.country}';
    } else {
      return 'Unknown location';
    }
  }
}
