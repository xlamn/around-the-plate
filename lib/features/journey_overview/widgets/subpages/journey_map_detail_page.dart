import 'package:dishes_repository/dishes_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mapbox_location_api/mapbox_location_api.dart';

import '../../../map/cubits/map_controller/map_controller_cubit.dart';
import '../../../map/cubits/map_data/map_data_cubit.dart';
import '../../../map/cubits/map_interaction/map_interaction_cubit.dart';
import '../../../map/view/map_widget.dart';

class JourneyMapDetailPage extends StatelessWidget {
  const JourneyMapDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => MapDataCubit(
              dishesRepository: context.read<DishesRepository>(),
              locationApi: MapboxLocationApi.instance,
            )..loadGeoJson(),
          ),
          BlocProvider(
            create: (_) => MapControllerCubit(),
          ),
          BlocProvider(
            create: (_) => MapInteractionCubit(),
          ),
        ],
        child: const CountryMap(),
      ),
    );
  }
}
