import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:money_transfer_app/Pages/App/index.dart';

class SSNPageStyles {
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

  double primaryHorizontalPadding;
  double primaryVerticalPadding;

  double formFieldHeight;
  double textFieldBorderRadius;

  TextStyle textFormFieldTextStyle;
  TextStyle hintTextStyle;
  TextStyle buttonStyle;

  SSNPageStyles(BuildContext context) {}
}

class SSNPageMobileStyles extends SSNPageStyles {
  SSNPageMobileStyles(BuildContext context) : super(context) {
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

    primaryHorizontalPadding = widthDp * 25;
    primaryVerticalPadding = widthDp * 20;

    formFieldHeight = widthDp * 56;
    textFieldBorderRadius = widthDp * 20;

    textFormFieldTextStyle = new TextStyle(
      color: AppColors.blackColor,
      fontSize: fontSp * 14.0,
    );
    hintTextStyle = new TextStyle(
      color: Colors.grey,
      fontSize: fontSp * 14.0,
      fontStyle: FontStyle.italic,
    );
    buttonStyle = TextStyle(fontSize: fontSp * 18, color: AppColors.whiteColor, fontWeight: FontWeight.bold);
  }
}
