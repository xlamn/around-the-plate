import 'package:app_theme/app_theme.dart';
import 'package:dishes_api/dishes_api.dart';
import 'package:dishes_repository/dishes_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_vision_dish_detection_api/google_vision_dish_detection_api.dart';
import 'package:isar_storage_dishes_api/isar_storage_dishes_api.dart';

import '../cubits/dish_detection/dish_detection_cubit.dart';
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
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => DishFormCubit(
            dishesRepository: context.read<DishesRepository>(),
          ),
        ),
        BlocProvider(
          create: (_) => DishDetectionCubit(
            imagePath: imagePath,
            dishDetectionApi: GoogleVisionDishDetectionApi.instance,
          ),
        ),
      ],
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
  State<DishFormBottomSheetView> createState() => _DishFormBottomSheetViewState();
}

class _DishFormBottomSheetViewState extends State<DishFormBottomSheetView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final ImagePathController<String> _imagePathController = ImagePathController<String>();
  late final TextEditingController _nameTextFieldController = TextEditingController();
  late final FSelectController<DishCategory> _categorySelectController = FSelectController();
  late final FSelectController<DishCuisine> _cuisineSelectController = FSelectController();
  late final FSelectController<DishLocation> _locationSelectController = FSelectController();
  late final FDateFieldController _dateFieldController = FDateFieldController();
  late final FContinuousSliderController _ratingSliderController;

  @override
  void initState() {
    super.initState();

    final dish = widget.dish;

    if (dish != null) {
      _imagePathController.path = dish.imagePath;
      _nameTextFieldController.text = dish.name;
      _dateFieldController.value = dish.date;
      _ratingSliderController = FContinuousSliderController(
        value: FSliderValue(max: dish.rating),
      );
      _categorySelectController.value = dish.category;
      _cuisineSelectController.value = dish.cuisine;
      _locationSelectController.value = dish.location;
    } else {
      _imagePathController.path = widget.imagePath;
      _ratingSliderController = FContinuousSliderController(
        value: FSliderValue(max: 0.5),
      );
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
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSizes.spacing16,
          AppSizes.spacing16,
          AppSizes.spacing16,
          AppSizes.spacing32,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            spacing: AppSizes.spacing16,
            children: [
              DishFormAppBar(
                isEditing: isEditing,
                onPressed: () async {
                  if (!_formKey.currentState!.validate()) return;
                  final dish = Dish.create(
                    id: widget.dish?.id ?? Isar.autoIncrement,
                    imagePath: _imagePathController.path ?? '',
                    name: _nameTextFieldController.text,
                    date: _dateFieldController.value,
                    category: _categorySelectController.value,
                    cuisine: _cuisineSelectController.value,
                    location: _locationSelectController.value,
                    rating: _ratingSliderController.value.max,
                  );
                  context.read<DishFormCubit>().addDish(dish);
                },
              ),
              DishFormImage(controller: _imagePathController),
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
    );
  }

  @override
  void dispose() {
    _imagePathController.dispose();
    _nameTextFieldController.dispose();
    _categorySelectController.dispose();
    _cuisineSelectController.dispose();
    _dateFieldController.dispose();
    _locationSelectController.dispose();
    _ratingSliderController.dispose();
    super.dispose();
  }
}
