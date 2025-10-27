import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubits/theme_selection_cubit.dart';

extension DarkTheme on BuildContext {
  bool get isDarkTheme {
    final mode = watch<ThemeModeCubit>().state;
    final systemBrightness = MediaQuery.of(this).platformBrightness;
    return switch (mode) {
      ThemeMode.dark => true,
      ThemeMode.light => false,
      ThemeMode.system => systemBrightness == Brightness.dark,
    };
  }
}
