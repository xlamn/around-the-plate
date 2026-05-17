import 'package:app_theme/app_theme.dart';
import 'package:directory_image_storage_api/directory_image_storage_api.dart';
import 'package:flutter/material.dart';
import 'package:trips_repository/trips_repository.dart';

import 'trip_placeholder.dart';

class TripContextBanner extends StatelessWidget {
  final Trip trip;
  final int selectedCount;

  const TripContextBanner({super.key, required this.trip, required this.selectedCount});

  @override
  Widget build(BuildContext context) {
    final imageFile = trip.coverImagePath.isNotEmpty
        ? DirectoryImageStorageApi.instance.getImageFile(trip.coverImagePath)
        : null;

    return Container(
      margin: const .symmetric(horizontal: AppSizes.spacing16, vertical: AppSizes.spacing8),
      padding: const .all(AppSizes.spacing12),
      decoration: BoxDecoration(
        color: context.theme.colors.muted,
        borderRadius: .circular(AppSizes.radiusM),
        border: .all(color: context.theme.colors.border, width: 0.5),
      ),
      child: Row(
        spacing: AppSizes.spacing12,
        children: [
          ClipRRect(
            borderRadius: .circular(AppSizes.radiusS),
            child: imageFile != null
                ? Image.file(imageFile, width: 52, height: 52, fit: BoxFit.cover)
                : TripPlaceholder(
                    width: 52,
                    height: 52,
                    borderRadius: .circular(AppSizes.radiusS),
                  ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: .start,
              spacing: AppSizes.spacing4,
              children: [
                Text(
                  trip.name,
                  style: context.theme.typography.sm.copyWith(fontWeight: .w600),
                  maxLines: 1,
                  overflow: .ellipsis,
                ),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: Align(
                    key: ValueKey(selectedCount),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      selectedCount == 0
                          ? 'No dishes selected'
                          : '$selectedCount ${selectedCount == 1 ? 'dish' : 'dishes'} selected',
                      style: context.theme.typography.xs.copyWith(
                        color: selectedCount > 0
                            ? context.theme.colors.primary
                            : context.theme.colors.mutedForeground,
                        fontWeight: selectedCount > 0 ? .w500 : .w400,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
