import 'package:flutter/material.dart';

class AppColors {
  static const Color scaffoldBackColor = Color(0xFFF8FBFF);
  static const Color scaffoldBackColor2 = Color(0xFFEEEFF3);
  static const Color primaryColor = Color(0xFF0BA4F2);
  static const Color secondaryColor = Color(0xFFF7A000);
  static const Color whiteColor = Colors.white;
  static const Color blackColor = Color(0XFF353942);

  static const Color deliveryOptionBackColor = Color(0xFF97D9EF);

  static const LinearGradient mainGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [Color(0xFF5780F2), Color(0xFF0BA4F2)],
  );

  static const List<Map<String, Color>> recipientColor = [
    {
      "backColor": Color(0xFFF45C92),
      "textColor": whiteColor,
    },
    {
      "backColor": Color(0xFFffd700),
      "textColor": blackColor,
    },
    {
      "backColor": Color(0xFFBC63CB),
      "textColor": whiteColor,
    },
    {
      "backColor": Color(0xFF8DA3AE),
      "textColor": whiteColor,
    },
    {
      "backColor": Color(0xFFE77071),
      "textColor": whiteColor,
    },
    {
      "backColor": Color(0xFF4AB4AC),
      "textColor": whiteColor,
    },
    {
      "backColor": Color(0xFFFDB73F),
      "textColor": whiteColor,
    },
    {
      "backColor": Color(0xFF52ff00),
      "textColor": whiteColor,
    },
    {
      "backColor": Color(0xFFd49ed4),
      "textColor": whiteColor,
    },
  ];
}
