import 'package:app_theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubits/map_controller/map_controller_cubit.dart';

class MapZoomControls extends StatelessWidget {
  const MapZoomControls({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: .min,
      spacing: AppSizes.spacing8,
      children: [
        FButton.icon(
          variant: FButtonVariant.secondary,
          onPress: () => context.read<MapControllerCubit>().zoomIn(),
          child: const Icon(FIcons.plus),
        ),
        FButton.icon(
          variant: FButtonVariant.secondary,
          onPress: () => context.read<MapControllerCubit>().zoomOut(),
          child: const Icon(FIcons.minus),
        ),
      ],
    );
  }
}
