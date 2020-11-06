import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:money_transfer_app/Pages/App/index.dart';

class SettingsPageStyles {
  double devicePixelRatio;
  double deviceWidth;
  double deviceHeight;
  double statusbarHeight;
  double bottombarHeight;
  double appbarHeight;
  double mainHeight;
  double shareWidth;
  double shareHeight;
  double widthDp;
  double heightDp;
  double fontSp;

  TextStyle titleStyle;

  double primaryHorizontalPadding;
  double primaryVerticalPadding;

  TextStyle labelStyle;
  TextStyle userNameStyle;

  double iconSize;

  TextStyle title1Style;
  TextStyle title2Style;

  TextStyle idStyle;

  SettingsPageStyles(BuildContext context) {}
}

class SettingsPageMobileStyles extends SettingsPageStyles {
  SettingsPageMobileStyles(BuildContext context) : super(context) {
    ScreenUtil.init(
      context,
      width: ResponsiveDesignSettings.mobileDesignWidth,
      height: ResponsiveDesignSettings.mobileDesignHeight,
      allowFontScaling: false,
    );

    devicePixelRatio = ScreenUtil.pixelRatio;
    deviceWidth = ScreenUtil.screenWidth;
    deviceHeight = ScreenUtil.screenHeight;
    statusbarHeight = ScreenUtil.statusBarHeight;
    appbarHeight = AppBar().preferredSize.height;
    bottombarHeight = ScreenUtil.bottomBarHeight;
    shareWidth = deviceWidth / 100;
    shareHeight = deviceHeight / 100;
    widthDp = ScreenUtil().setWidth(1);
    heightDp = ScreenUtil().setHeight(1);
    fontSp = ScreenUtil().setSp(1, allowFontScalingSelf: false);
    // mainHeight = deviceHeight - bottombarHeight;
    mainHeight = deviceHeight - 93;

    titleStyle = TextStyle(fontSize: fontSp * 20, color: AppColors.whiteColor, fontFamily: "Exo-SemiBold");

    primaryHorizontalPadding = widthDp * 20;
    primaryVerticalPadding = widthDp * 25;

    userNameStyle = TextStyle(fontSize: fontSp * 20, color: Color(0xFF353942), fontFamily: "Exo-SemiBold");
    idStyle = TextStyle(fontSize: fontSp * 14, color: Color(0xFF353942).withOpacity(0.5), fontFamily: "Exo-Medium");

    iconSize = widthDp * 20;

    title1Style = TextStyle(fontSize: fontSp * 30, color: AppColors.primaryColor, fontWeight: FontWeight.bold);
    title2Style = TextStyle(fontSize: fontSp * 30, color: AppColors.whiteColor, fontWeight: FontWeight.bold);
    labelStyle = TextStyle(fontSize: fontSp * 16, color: AppColors.blackColor);
  }
}
