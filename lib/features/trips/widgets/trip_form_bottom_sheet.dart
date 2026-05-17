import 'package:app_theme/app_theme.dart';
import 'package:directory_image_storage_api/directory_image_storage_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:trips_repository/trips_repository.dart';

import '../../../widgets/form_app_bar.dart';
import '../cubits/trip_form/trip_form_cubit.dart';
import 'controls/controls.dart';

enum TripFormResult { created, updated, deleted }

class TripFormBottomSheet extends StatelessWidget {
  final Trip? trip;

  const TripFormBottomSheet({super.key, this.trip});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => TripFormCubit(
        tripsRepository: context.read<TripsRepository>(),
      ),
      child: TripFormBottomSheetView(trip: trip),
    );
  }
}

class TripFormBottomSheetView extends StatefulWidget {
  final Trip? trip;

  const TripFormBottomSheetView({super.key, this.trip});

  @override
  State<TripFormBottomSheetView> createState() => _TripFormBottomSheetViewState();
}

class _TripFormBottomSheetViewState extends State<TripFormBottomSheetView> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _descController;
  String? _coverImagePath;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.trip?.name ?? '');
    _descController = TextEditingController(text: widget.trip?.description ?? '');
    _coverImagePath = widget.trip?.coverImagePath;
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.trip != null;

    return BlocListener<TripFormCubit, TripFormState>(
      listener: (context, state) {
        if (state.status == TripFormStatus.success) {
          Navigator.of(context).pop(
            isEditing ? TripFormResult.updated : TripFormResult.created,
          );
        } else if (state.status == TripFormStatus.deleted) {
          Navigator.of(context).pop(TripFormResult.deleted);
        }
      },
      child: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            color: context.theme.colors.background,
            borderRadius: const .vertical(top: .circular(AppSizes.radiusL)),
          ),
          padding: const .all(
            AppSizes.spacing16,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: .min,
              spacing: AppSizes.spacing16,
              children: [
                FormAppBar(
                  saveLabel: isEditing ? 'Save changes' : 'Create trip',
                  onPressed: () async => _save(),
                ),
                Builder(
                  builder: (context) {
                    final coverImageFile = _coverImagePath != null
                        ? DirectoryImageStorageApi.instance.getImageFile(_coverImagePath!)
                        : null;
                    return GestureDetector(
                      onTap: _pickCoverImage,
                      child: Container(
                        height: 140,
                        decoration: BoxDecoration(
                          color: context.theme.colors.muted,
                          borderRadius: .circular(AppSizes.radiusM),
                          border: .all(color: context.theme.colors.border),
                        ),
                        child: coverImageFile != null
                            ? ClipRRect(
                                borderRadius: .circular(AppSizes.radiusM),
                                child: Stack(
                                  fit: .expand,
                                  children: [
                                    Image.file(
                                      coverImageFile,
                                      fit: .cover,
                                    ),
                                    Positioned(
                                      top: AppSizes.spacing8,
                                      right: AppSizes.spacing8,
                                      child: GestureDetector(
                                        onTap: () => setState(() => _coverImagePath = null),
                                        child: Container(
                                          padding: const .all(AppSizes.spacing4),
                                          decoration: BoxDecoration(
                                            color: Colors.black54,
                                            borderRadius: .circular(AppSizes.radiusS),
                                          ),
                                          child: const Icon(
                                            Icons.close,
                                            size: 16,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : Column(
                                mainAxisAlignment: .center,
                                crossAxisAlignment: .stretch,
                                spacing: AppSizes.spacing8,
                                children: [
                                  Icon(
                                    FIcons.image,
                                    size: AppSizes.iconL,
                                    color: context.theme.colors.mutedForeground,
                                  ),
                                  Text(
                                    'Add cover photo',
                                    style: context.theme.typography.sm.copyWith(
                                      color: context.theme.colors.mutedForeground,
                                    ),
                                    textAlign: .center,
                                  ),
                                ],
                              ),
                      ),
                    );
                  },
                ),
                TripFormNameTextField(controller: _nameController),
                TripFormDescriptionTextField(controller: _descController),
                if (isEditing) TripFormDeleteButton(trip: widget.trip),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _pickCoverImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) setState(() => _coverImagePath = picked.path);
  }

  void _save() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final name = _nameController.text.trim();

    final trip = widget.trip != null
        ? widget.trip!.copyWith(
            name: name,
            description: _descController.text.trim().isEmpty ? null : _descController.text.trim(),
            coverImagePath: _coverImagePath ?? '',
            dishIds: widget.trip!.dishIds,
          )
        : Trip.create(
            name: name,
            description: _descController.text.trim().isEmpty ? null : _descController.text.trim(),
            coverImagePath: _coverImagePath ?? '',
            dishIds: const [],
          );

    context.read<TripFormCubit>().saveTrip(trip);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    super.dispose();
  }
}
