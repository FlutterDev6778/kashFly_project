import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:money_transfer_app/Pages/App/index.dart';

class PersonalDetailPageStyles {
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

  double textFieldBorderRadius;
  double iconSize;

  TextStyle title1Style;
  TextStyle title2Style;
  TextStyle tabItemStyle;
  TextStyle labelTextStyle;
  TextStyle descriptionlabelTextStyle;
  TextStyle textFormFieldTextStyle;
  TextStyle hintTextStyle;
  TextStyle buttonTextStyle;

  PersonalDetailPageStyles(BuildContext context) {}
}

class PersonalDetailPageMobileStyles extends PersonalDetailPageStyles {
  PersonalDetailPageMobileStyles(BuildContext context) : super(context) {
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

    primaryHorizontalPadding = widthDp * 30;
    primaryVerticalPadding = widthDp * 30;

    textFieldBorderRadius = widthDp * 10;
    iconSize = widthDp * 20;

    title1Style = TextStyle(fontSize: fontSp * 25, color: AppColors.primaryColor, fontWeight: FontWeight.bold);
    title2Style = TextStyle(fontSize: fontSp * 25, color: AppColors.whiteColor, fontWeight: FontWeight.bold);
    tabItemStyle = TextStyle(fontSize: fontSp * 20, color: AppColors.whiteColor);
    descriptionlabelTextStyle = new TextStyle(color: Colors.grey, fontSize: fontSp * 18.0);
    labelTextStyle = new TextStyle(color: AppColors.blackColor, fontSize: fontSp * 18.0);
    textFormFieldTextStyle = new TextStyle(color: AppColors.blackColor, fontSize: fontSp * 16.0);
    hintTextStyle = new TextStyle(color: Colors.grey, fontSize: fontSp * 16.0, fontStyle: FontStyle.italic);
    buttonTextStyle = new TextStyle(color: AppColors.whiteColor, fontSize: fontSp * 18.0);
  }
}
