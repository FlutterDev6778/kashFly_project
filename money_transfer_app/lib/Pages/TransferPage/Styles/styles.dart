import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:money_transfer_app/Pages/App/index.dart';

class TransferPageStyles {
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

  double deliveryOptionWidth;
  double deliveryOptionHeight;

  TextStyle title1Style;
  TextStyle title2Style;
  TextStyle labelStyle;
  TextStyle bigTextStyle;
  TextStyle selectedBigTextStyle;
  TextStyle textStyle;
  TextStyle commentHintTextStyle;
  TextStyle buttonTextStyle;
  TextStyle limitErrorTextStyle;
  TextStyle limitTextStyle;

  TransferPageStyles(BuildContext context) {}
}

class TransferPageMobileStyles extends TransferPageStyles {
  TransferPageMobileStyles(BuildContext context) : super(context) {
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
    mainHeight = deviceHeight;

    primaryHorizontalPadding = widthDp * 30;
    primaryVerticalPadding = widthDp * 30;

    deliveryOptionWidth = widthDp * 140;
    deliveryOptionHeight = widthDp * 140;

    title1Style = TextStyle(fontSize: fontSp * 30, color: AppColors.primaryColor, fontWeight: FontWeight.bold);
    title2Style = TextStyle(fontSize: fontSp * 30, color: AppColors.whiteColor, fontWeight: FontWeight.bold);
    labelStyle = TextStyle(fontSize: fontSp * 17, color: AppColors.primaryColor);
    bigTextStyle = TextStyle(fontSize: fontSp * 20, color: AppColors.blackColor, fontWeight: FontWeight.bold);
    selectedBigTextStyle = TextStyle(fontSize: fontSp * 20, color: AppColors.whiteColor, fontWeight: FontWeight.bold);
    textStyle = TextStyle(fontSize: fontSp * 16, color: AppColors.blackColor);
    commentHintTextStyle = TextStyle(fontSize: fontSp * 14, color: Colors.grey);
    buttonTextStyle = TextStyle(fontSize: fontSp * 18, color: AppColors.whiteColor);
    limitTextStyle = TextStyle(fontSize: fontSp * 13, color: Colors.blueAccent);
    limitErrorTextStyle = TextStyle(fontSize: fontSp * 13, color: Colors.red);
  }
}
