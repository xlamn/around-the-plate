import 'dart:io';

import 'package:around_the_plate/features/add_dish/widgets/controls/add_dish_origin_select.dart';
import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

import 'widgets/add_dish_app_bar.dart';
import 'widgets/controls/add_dish_date_field.dart';
import 'widgets/controls/add_dish_name_text_field.dart';
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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 16,
          children: [
            AddDishAppBar(),
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
