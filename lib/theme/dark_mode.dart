import 'package:flutter/material.dart';
import 'package:habit_tracker/util/appcolors.dart';

ThemeData darkMode = ThemeData(
  colorScheme: ColorScheme.dark(
    surface: DarkColors.surface,
    primary: DarkColors.primary,
    secondary: DarkColors.secondary,
    tertiary: DarkColors.tertiary,
    inversePrimary: DarkColors.inversePrimary,
  )
);