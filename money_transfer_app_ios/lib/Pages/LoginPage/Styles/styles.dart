import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:money_transfer_app/Pages/App/index.dart';

class LoginPageStyles {
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

  TextStyle selectedTapStyle;
  TextStyle unSelectedTapStyle;
  TextStyle labelStyle;
  TextStyle textFormFieldTextStyle;
  TextStyle hintTextStyle;
  TextStyle buttonTextStyle;
  TextStyle descriptionTextStyle;
  TextStyle linkTextStyle;

  double formFieldHeight;
  double textFieldBorderRadius;
  double iconSize;

  LoginPageStyles(BuildContext context) {}
}

class LoginPageMobileStyles extends LoginPageStyles {
  LoginPageMobileStyles(BuildContext context) : super(context) {
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
    mainHeight = deviceHeight;

    formFieldHeight = widthDp * 56;
    textFieldBorderRadius = widthDp * 20;
    iconSize = widthDp * 20;

    selectedTapStyle = new TextStyle(
      color: Color(0xFF179FF2),
      fontSize: fontSp * 18,
      fontFamily: "Exo-SemiBold",
    );

    unSelectedTapStyle = new TextStyle(
      color: Color(0xFF353942),
      fontSize: fontSp * 18,
      fontFamily: "Exo-SemiBold",
    );

    labelStyle = new TextStyle(
      color: Color(0xFF353942),
      fontSize: fontSp * 14.0,
      fontFamily: "Exo-SemiBold",
    );

    textFormFieldTextStyle = new TextStyle(
      color: AppColors.blackColor,
      fontSize: fontSp * 14.0,
    );

    hintTextStyle = new TextStyle(
      color: Colors.grey,
      fontSize: fontSp * 14.0,
      fontStyle: FontStyle.italic,
    );

    buttonTextStyle = new TextStyle(
      color: AppColors.whiteColor,
      fontSize: fontSp * 18.0,
      fontFamily: "Exo-SemiBold",
    );

    descriptionTextStyle = new TextStyle(
      color: Color(0xFF2B3F46),
      fontSize: fontSp * 14.0,
    );

    linkTextStyle = new TextStyle(
      color: Color(0xFF179FF2),
      fontSize: fontSp * 14.0,
    );
  }
}
