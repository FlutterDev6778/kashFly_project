import 'package:flutter/material.dart';
import './colors.dart';

ThemeData buildThemeData(BuildContext context) {
  // final baseTheme = ThemeData(fontFamily: "Merriweather");
  final baseTheme = ThemeData();

  return baseTheme.copyWith(
    primaryColor: AppColors.primaryColor,
  );
}
