import 'dart:io';

import 'package:app_theme/app_theme.dart';
import 'package:directory_image_storage_api/directory_image_storage_api.dart';
import 'package:dishes_api/dishes_api.dart';
import 'package:dishes_repository/dishes_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isar_storage_dishes_api/isar_storage_dishes_api.dart';

import '../cubits/dish_form_cubit.dart';
import '../widgets/controls/controls.dart';
import '../widgets/dish_form_app_bar.dart';
import '../widgets/dish_form_delete_button.dart';

enum DishFormResult {
  updated,
  deleted,
}

class DishFormBottomSheet extends StatelessWidget {
  final String? imagePath;
  final Dish? dish;

  const DishFormBottomSheet({
    super.key,
    this.imagePath,
    this.dish,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DishFormCubit(
        dishesRepository: context.read<DishesRepository>(),
      ),
      child: DishFormBottomSheetView(
        imagePath: imagePath,
        dish: dish,
      ),
    );
  }
}

class DishFormBottomSheetView extends StatefulWidget {
  final String? imagePath;
  final Dish? dish;

  const DishFormBottomSheetView({
    super.key,
    this.imagePath,
    this.dish,
  });

  @override
  State<DishFormBottomSheetView> createState() =>
      _DishFormBottomSheetViewState();
}

class _DishFormBottomSheetViewState extends State<DishFormBottomSheetView>
    with TickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameTextFieldController =
      TextEditingController();
  late final FSelectController<DishCategory> _categorySelectController =
      FSelectController(vsync: this);
  late final FSelectController<DishCuisine> _cuisineSelectController =
      FSelectController(vsync: this);
  late final FSelectController<DishLocation> _locationSelectController =
      FSelectController(vsync: this);
  late final FDateFieldController _dateFieldController = FDateFieldController(
    vsync: this,
  );
  late final FContinuousSliderController _ratingSliderController =
      FContinuousSliderController(
        selection: FSliderSelection(max: 0.5),
      );

  @override
  void initState() {
    super.initState();

    final dish = widget.dish;
    if (dish != null) {
      _nameTextFieldController.text = dish.name;
      _dateFieldController.value = dish.date;
      _ratingSliderController.selection = FSliderSelection(
        max: dish.rating,
      );
      _categorySelectController.value = dish.category;
      _cuisineSelectController.value = dish.cuisine;
      _locationSelectController.value = dish.location;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.dish != null;
    return BlocListener<DishFormCubit, DishFormState>(
      listener: (context, state) {
        if (state.status == DishFormStatus.success) {
          Navigator.pop(context, DishFormResult.updated);
        } else if (state.status == DishFormStatus.deleted) {
          Navigator.pop(context, DishFormResult.deleted);
        }
      },
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              spacing: 16,
              children: [
                DishFormAppBar(
                  isEditing: isEditing,
                  onPressed: () async {
                    if (!_formKey.currentState!.validate()) return;
                    final dish = Dish(
                      id: widget.dish?.id ?? Isar.autoIncrement,
                      name: _nameTextFieldController.text,
                      date: _dateFieldController.value,
                      categoryValue: _categorySelectController.value?.index,
                      imagePath:
                          widget.imagePath ?? widget.dish?.imagePath ?? '',
                      cuisineValue: _cuisineSelectController.value?.index,
                      location: _locationSelectController.value,
                      rating: _ratingSliderController.selection.offset.max,
                    );
                    context.read<DishFormCubit>().addDish(dish);
                  },
                ),
                SizedBox(
                  width: 120,
                  height: 120,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.file(
                      widget.imagePath != null
                          ? File(widget.imagePath!)
                          : DirectoryImageStorageApi.instance.getImageFile(
                              widget.dish?.imagePath ?? '',
                            )!,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                DishFormNameTextField(controller: _nameTextFieldController),
                DishFormCategorySelect(controller: _categorySelectController),
                DishFormCuisineSelect(controller: _cuisineSelectController),
                DishFormDateField(controller: _dateFieldController),
                DishFormLocationSelect(controller: _locationSelectController),
                DishFormRatingSlider(controller: _ratingSliderController),
                if (isEditing) DishFormDeleteButton(dish: widget.dish!),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameTextFieldController.dispose();
    _categorySelectController.dispose();
    _cuisineSelectController.dispose();
    _dateFieldController.dispose();
    _locationSelectController.dispose();
    _ratingSliderController.dispose();
    super.dispose();
  }
}
