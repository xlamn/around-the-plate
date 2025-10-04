import 'dart:io';

import 'package:dishes_repository/dishes_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forui/forui.dart';

import '../cubits/add_dish/add_dish_cubit.dart';
import '../widgets/add_dish_app_bar.dart';
import '../widgets/controls/controls.dart';

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
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameTextFieldController =
      TextEditingController();
  late final FSelectController<DishCategory> _categorySelectController =
      FSelectController(vsync: this);
  late final FSelectController<String> _originSelectController =
      FSelectController(vsync: this);
  late final FSelectController<String> _locationSelectController =
      FSelectController(vsync: this);
  late final FDateFieldController _dateFieldController = FDateFieldController(
    vsync: this,
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
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              spacing: 16,
              children: [
                AddDishAppBar(
                  onPressed: () async {
                    if (!_formKey.currentState!.validate()) return;
                    await context.read<AddDishCubit>().addDish(
                      Dish(
                        name: _nameTextFieldController.text,
                        date: _dateFieldController.value,
                        category: _categorySelectController.value,
                        imagePath: widget.imagePath,
                        origin: _originSelectController.value,
                        rating: _ratingSliderController.selection.offset.max,
                      ),
                    );
                  },
                ),
                SizedBox(
                  width: 120,
                  height: 120,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.file(
                      File(widget.imagePath),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                AddDishNameTextField(controller: _nameTextFieldController),
                AddDishCategorySelect(controller: _categorySelectController),
                AddDishOriginSelect(controller: _originSelectController),
                AddDishDateField(controller: _dateFieldController),
                AddDishLocationSelect(controller: _locationSelectController),
                AddDishRatingSlider(controller: _ratingSliderController),
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
    _originSelectController.dispose();
    _dateFieldController.dispose();
    _ratingSliderController.dispose();
    super.dispose();
  }
}
