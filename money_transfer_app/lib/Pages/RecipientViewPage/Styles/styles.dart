import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:money_transfer_app/Pages/App/index.dart';

class RecipientViewPageStyles {
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

  double iconSize;
  double formFieldBorderRadius;
  double formFieldHeight;
  double buttonHeight;

  TextStyle title1Style;
  TextStyle title2Style;
  TextStyle textStyle;
  TextStyle hintStyle;
  TextStyle buttonTextStyle;

  RecipientViewPageStyles(BuildContext context) {}
}

class RecipientViewPageMobileStyles extends RecipientViewPageStyles {
  RecipientViewPageMobileStyles(BuildContext context) : super(context) {
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

    primaryHorizontalPadding = widthDp * 30;
    primaryVerticalPadding = widthDp * 20;

    iconSize = widthDp * 25;
    formFieldBorderRadius = widthDp * 20;
    formFieldHeight = widthDp * 56;
    buttonHeight = widthDp * 56;

    title1Style = TextStyle(fontSize: fontSp * 25, color: AppColors.primaryColor, fontWeight: FontWeight.bold);
    title2Style = TextStyle(fontSize: fontSp * 25, color: AppColors.whiteColor, fontWeight: FontWeight.bold);
    textStyle = TextStyle(fontSize: fontSp * 16, color: AppColors.blackColor);
    hintStyle = TextStyle(fontSize: fontSp * 16, color: Colors.grey, fontStyle: FontStyle.italic);
    buttonTextStyle = TextStyle(fontSize: fontSp * 18, color: AppColors.whiteColor);
  }
}
