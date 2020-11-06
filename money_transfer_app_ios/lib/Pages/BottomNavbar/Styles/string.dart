import 'package:flutter/material.dart';
import 'package:money_transfer_app/Pages/App/Styles/index.dart';

class BottomNavbarString {
  static List<Map<String, dynamic>> navbarItemList = [
    {
      "icon": AppAssets.homeIcon,
      "title": "Home",
      "activeColor": AppColors.primaryColor,
      "inactiveColor": Colors.grey,
    },
    {
      "icon": AppAssets.sendIcon,
      "title": "Send",
      "activeColor": AppColors.primaryColor,
      "inactiveColor": Colors.grey,
    },
    {
      "icon": AppAssets.activityIcon,
      "title": "Activity",
      "activeColor": AppColors.primaryColor,
      "inactiveColor": Colors.grey,
    },
    {
      "icon": AppAssets.settingIcon,
      "title": "Setting",
      "activeColor": AppColors.primaryColor,
      "inactiveColor": Colors.grey,
    },
  ];
}
