import 'dart:async';

import 'package:dishes_api/dishes_api.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:location_api/location_api.dart';
import 'package:permission_handler/permission_handler.dart';

part 'dish_form_location_search_state.dart';

class DishFormLocationSearchCubit extends Cubit<DishFormLocationSearchState> {
  final LocationApi _service;
  Timer? _debounce;
  Completer<List<DishLocation>>? _pendingSearch;

  DishFormLocationSearchCubit({required LocationApi service})
    : _service = service,
      super(const DishFormLocationSearchState());

  Future<void> init() async {
    final granted = (await Permission.location.status).isGranted;
    if (isClosed) return;
    if (!granted) {
      emit(state.copyWith(permissionGranted: false));
      return;
    }
    final current = await _service.getCurrentLocation();
    if (isClosed) return;
    emit(
      state.copyWith(
        permissionGranted: true,
        currentLocation: current,
        results: current != null ? [current] : [],
      ),
    );
  }

  Future<List<DishLocation>> search(String query) {
    _debounce?.cancel();

    // Unblock any pending search with cached results so FSelect doesn't hang
    if (_pendingSearch != null && !_pendingSearch!.isCompleted) {
      _pendingSearch!.complete(state.results);
    }

    if (query.isEmpty) {
      final results = state.currentLocation != null ? [state.currentLocation!] : <DishLocation>[];
      if (!isClosed) emit(state.copyWith(results: results));
      _pendingSearch = null;
      return Future.value(results);
    }

    final completer = Completer<List<DishLocation>>();
    _pendingSearch = completer;

    _debounce = Timer(const Duration(milliseconds: 350), () async {
      if (isClosed || completer.isCompleted) return;
      final results = await _service.searchLocations(
        query,
        currentLocation: state.currentLocation,
      );
      if (!isClosed && !completer.isCompleted) {
        emit(state.copyWith(results: results));
        completer.complete(results);
      }
      _pendingSearch = null;
    });

    return completer.future;
  }

  @override
  Future<void> close() {
    _debounce?.cancel();
    if (_pendingSearch != null && !_pendingSearch!.isCompleted) {
      _pendingSearch!.complete(state.results);
    }
    return super.close();
  }
}
