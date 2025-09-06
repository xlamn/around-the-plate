import 'dart:io';

import 'package:dishes_repository/dishes_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forui/forui.dart';

import '../cubits/add_dish/add_dish_cubit.dart';
import '../cubits/add_dish/add_dish_state.dart';
import '../widgets/add_dish_app_bar.dart';
import '../widgets/controls/add_dish_category_select.dart';
import '../widgets/controls/add_dish_date_field.dart';
import '../widgets/controls/add_dish_name_text_field.dart';
import '../widgets/controls/add_dish_origin_select.dart';
import '../widgets/controls/add_dish_rating_slider.dart';

class AddDishBottomSheet extends StatelessWidget {
  final String imagePath;

  const AddDishBottomSheet({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AddDishCubit(
        dishesRepository: context.read<DishesRepository>(),
      ),
      child: AddDishBottomSheetView(imagePath: imagePath),
    );
  }
}

class AddDishBottomSheetView extends StatefulWidget {
  final String imagePath;

  const AddDishBottomSheetView({super.key, required this.imagePath});

  @override
  State<AddDishBottomSheetView> createState() => _AddDishBottomSheetViewState();
}

class _AddDishBottomSheetViewState extends State<AddDishBottomSheetView>
    with TickerProviderStateMixin {
  late final TextEditingController _nameTextFieldController =
      TextEditingController();
  late final FSelectController<DishCategory> _categorySelectController =
      FSelectController(vsync: this);
  late final FSelectController<String> _originSelectController =
      FSelectController(vsync: this);
  late final FDateFieldController _dateFieldController = FDateFieldController(
    vsync: this,
    initialDate: DateTime.now(),
  );
  late final FContinuousSliderController _ratingSliderController =
      FContinuousSliderController(
        selection: FSliderSelection(max: 0.5),
      );

  @override
  Widget build(BuildContext context) {
    return BlocListener<AddDishCubit, AddDishState>(
      listener: (context, state) {
        if (state.status == AddDishStatus.success) {
          Navigator.pop(context);
        }
      },
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            spacing: 16,
            children: [
              AddDishAppBar(
                getDish: () => Dish(
                  name: _nameTextFieldController.text,
                  date: _dateFieldController.value ?? DateTime.now(),
                  category:
                      _categorySelectController.value ?? DishCategory.unknown,
                  imagePath: widget.imagePath,
                  origin: _originSelectController.value ?? '',
                  rating: _ratingSliderController
                      .selection
                      .extent
                      .max, // TODO: find rating
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: SizedBox(
                      height: 100,
                      width: 100,
                      child: Image.file(File(widget.imagePath)),
                    ),
                  ),
                  AddDishNameTextField(
                    controller: _nameTextFieldController,
                  ),
                ],
              ),
              AddDishCategorySelect(controller: _categorySelectController),
              AddDishOriginSelect(controller: _originSelectController),
              AddDishDateField(controller: _dateFieldController),
              AddDishRatingSlider(controller: _ratingSliderController),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameTextFieldController.dispose();
    _originSelectController.dispose();
    _dateFieldController.dispose();
    _ratingSliderController.dispose();
    super.dispose();
  }
}
