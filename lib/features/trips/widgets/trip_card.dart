import 'package:app_theme/app_theme.dart';
import 'package:directory_image_storage_api/directory_image_storage_api.dart';
import 'package:flutter/material.dart';
import 'package:trips_repository/trips_repository.dart';

import '../view/trip_detail_page.dart';
import 'trip_placeholder.dart';

class TripCard extends StatelessWidget {
  final Trip trip;
  final double? width;

  const TripCard({super.key, required this.trip, this.width = 140});

  @override
  Widget build(BuildContext context) {
    final imageFile = trip.coverImagePath.isNotEmpty
        ? DirectoryImageStorageApi.instance.getImageFile(trip.coverImagePath)
        : null;

    return GestureDetector(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => TripDetailPage(tripId: trip.id)),
      ),
      child: Container(
        width: width,
        decoration: BoxDecoration(
          color: context.theme.colors.card,
          borderRadius: .circular(AppSizes.radiusM),
          border: Border.all(color: context.theme.colors.border, width: 0.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.12),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: .stretch,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const .vertical(
                  top: .circular(AppSizes.radiusM),
                ),
                child: imageFile != null
                    ? Image.file(imageFile, fit: .cover)
                    : const TripPlaceholder(
                        borderRadius: .vertical(
                          top: .circular(AppSizes.radiusM),
                        ),
                      ),
              ),
            ),
            Padding(
              padding: const .all(AppSizes.spacing8),
              child: Column(
                crossAxisAlignment: .start,
                spacing: 2,
                children: [
                  Text(
                    trip.name,
                    style: context.theme.typography.sm.copyWith(
                      fontWeight: .w600,
                      height: 1.2,
                    ),
                    maxLines: 1,
                    overflow: .ellipsis,
                  ),
                  Text(
                    '${trip.dishIds.length} ${trip.dishIds.length == 1 ? 'dish' : 'dishes'}',
                    style: context.theme.typography.xs.copyWith(
                      color: context.theme.colors.mutedForeground,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NewTripCard extends StatelessWidget {
  final VoidCallback onTap;

  const NewTripCard({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 140,
        decoration: BoxDecoration(
          color: context.theme.colors.muted,
          borderRadius: BorderRadius.circular(AppSizes.radiusM),
          border: Border.all(
            color: context.theme.colors.border,
            width: 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: AppSizes.spacing8,
          children: [
            Icon(
              FIcons.plus,
              size: AppSizes.iconL,
              color: context.theme.colors.mutedForeground,
            ),
            Text(
              'New Trip',
              style: context.theme.typography.sm.copyWith(
                color: context.theme.colors.mutedForeground,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
