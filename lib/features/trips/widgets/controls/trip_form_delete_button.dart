import 'package:app_theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trips_api/trips_api.dart';

import '../../cubits/trip_form/trip_form_cubit.dart';

class TripFormDeleteButton extends StatelessWidget {
  final Trip? trip;

  const TripFormDeleteButton({super.key, this.trip});

  @override
  Widget build(BuildContext context) {
    return FButton(
      variant: .destructive,
      onPress: () async {
        if (trip == null) return;
        await showFDialog(
          context: context,
          builder: (_, style, animation) {
            return FDialog(
              animation: animation,
              builder: (_, style) {
                return Padding(
                  padding: const .all(AppSizes.spacing16),
                  child: Column(
                    crossAxisAlignment: .start,
                    mainAxisSize: .min,
                    spacing: AppSizes.spacing16,
                    children: [
                      DefaultTextStyle.merge(
                        style: style.bodyTextStyle,
                        child: const Text('Are you sure you want to delete this trip?'),
                      ),
                      Row(
                        mainAxisAlignment: .end,
                        spacing: AppSizes.spacing8,
                        children: [
                          FButton(
                            variant: .destructive,
                            onPress: () async {
                              context.read<TripFormCubit>().deleteTrip(trip!);
                              if (!context.mounted) return;
                              Navigator.pop(context);
                            },
                            child: const Text('Delete Trip'),
                          ),
                          FButton(
                            variant: .ghost,
                            onPress: () => Navigator.pop(context),
                            child: const Text('Cancel'),
                          ),
                        ].toList(),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
      child: const Text('Delete trip'),
    );
  }
}
