import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:money_transfer_app/Pages/App/index.dart';

class RegisterPageStyles {
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

  double formPanelTopPadding;
  double formPanelHorizontalPadding;
  double formPanelHeight;

  double textFieldBorderRadius;
  double iconSize;

  TextStyle titleTextStyle;
  TextStyle textFormFieldTextStyle;
  TextStyle hintTextStyle;
  TextStyle buttonTextStyle;
  TextStyle descriptionTextStyle;
  TextStyle linkTextStyle;

  RegisterPageStyles(BuildContext context) {}
}

class RegisterPageMobileStyles extends RegisterPageStyles {
  RegisterPageMobileStyles(BuildContext context) : super(context) {
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
    mainHeight = deviceHeight - widthDp * 80;

    formPanelTopPadding = widthDp * 130;
    formPanelHorizontalPadding = widthDp * 32;
    formPanelHeight = widthDp * 500;

    textFieldBorderRadius = widthDp * 10;
    iconSize = widthDp * 20;

    titleTextStyle = new TextStyle(
      color: AppColors.blackColor,
      fontWeight: FontWeight.bold,
      fontSize: fontSp * 35.0,
    );

    textFormFieldTextStyle = new TextStyle(
      color: AppColors.blackColor,
      fontSize: fontSp * 16.0,
    );

    hintTextStyle = new TextStyle(
      color: Colors.grey,
      fontSize: fontSp * 16.0,
      fontStyle: FontStyle.italic,
    );

    buttonTextStyle = new TextStyle(
      color: AppColors.whiteColor,
      fontSize: fontSp * 18.0,
    );

    descriptionTextStyle = new TextStyle(
      color: Colors.grey,
      fontSize: fontSp * 14.0,
    );

    linkTextStyle = new TextStyle(
      color: Colors.red,
      fontSize: fontSp * 14.0,
    );
  }
}
