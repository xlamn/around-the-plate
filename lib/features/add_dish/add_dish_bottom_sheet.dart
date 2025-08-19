import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forui/forui.dart';

import 'cubits/add_dish/add_dish_cubit.dart';
import 'cubits/add_dish/add_dish_state.dart';
import 'widgets/add_dish_app_bar.dart';
import 'widgets/controls/add_dish_date_field.dart';
import 'widgets/controls/add_dish_name_text_field.dart';
import 'widgets/controls/add_dish_origin_select.dart';
import 'widgets/controls/add_dish_rating_slider.dart';

class AddDishBottomSheet extends StatefulWidget {
  final String imagePath;

  const AddDishBottomSheet({super.key, required this.imagePath});

  @override
  State<AddDishBottomSheet> createState() => _AddDishBottomSheetState();
}

class _AddDishBottomSheetState extends State<AddDishBottomSheet>
    with TickerProviderStateMixin {
  late final TextEditingController _nameTextFieldController =
      TextEditingController();
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
  late final _addDishCubit = AddDishCubit();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _addDishCubit,
      child: BlocListener<AddDishCubit, AddDishState>(
        listener: (context, state) {
          if (state is AddDishSuccess) {
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
                  nameController: _nameTextFieldController,
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
                AddDishOriginSelect(controller: _originSelectController),
                AddDishDateField(controller: _dateFieldController),
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
    _originSelectController.dispose();
    _dateFieldController.dispose();
    _ratingSliderController.dispose();
    _addDishCubit.close();
    super.dispose();
  }
}
