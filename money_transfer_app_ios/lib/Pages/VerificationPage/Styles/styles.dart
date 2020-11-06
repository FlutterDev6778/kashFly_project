import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:money_transfer_app/Pages/App/index.dart';

class VerificationPageStyles {
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
  TextStyle labelStyle;

  double formPanelVerticalPadding;
  double formPanelHorizontalPadding;

  TextStyle pinCodeTextStyle;

  TextStyle descriptionTextStyle;
  TextStyle linkTextStyle;

  double buttonHeight;
  TextStyle buttonTextStyle;

  VerificationPageStyles(BuildContext context) {}
}

class VerificationPageMobileStyles extends VerificationPageStyles {
  VerificationPageMobileStyles(BuildContext context) : super(context) {
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

    titleStyle = TextStyle(fontSize: fontSp * 20, color: AppColors.whiteColor, fontFamily: "Exo-SemiBold");

    formPanelVerticalPadding = widthDp * 25;
    formPanelHorizontalPadding = widthDp * 25;

    labelStyle = new TextStyle(color: AppColors.blackColor, fontWeight: FontWeight.w600, fontSize: fontSp * 24.0);
    pinCodeTextStyle = new TextStyle(color: AppColors.blackColor, fontWeight: FontWeight.w500, fontSize: fontSp * 25.0);

    descriptionTextStyle = new TextStyle(color: Color(0xFF272742), fontSize: fontSp * 14.0, fontFamily: "Exo-Medium");
    linkTextStyle = new TextStyle(
      color: Color(0xFF1A9EF2),
      fontSize: fontSp * 14.0,
      fontFamily: "Exo-Medium",
      decorationStyle: TextDecorationStyle.solid,
      decorationColor: Color(0xFF1A9EF2),
      decoration: TextDecoration.underline,
    );

    buttonHeight = widthDp * 50;
    buttonTextStyle = new TextStyle(color: AppColors.whiteColor, fontSize: fontSp * 18.0, fontFamily: "Exo-SemiBold");
  }
}
