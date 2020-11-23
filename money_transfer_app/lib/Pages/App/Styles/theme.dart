import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import './colors.dart';

ThemeData buildThemeData(BuildContext context) {
  return ThemeData(
    fontFamily: "Exo",
    primaryColor: AppColors.primaryColor,
    buttonColor: AppColors.primaryColor,
    scaffoldBackgroundColor: AppColors.scaffoldBackColor,
  );
}
