import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:money_transfer_app/Pages/App/index.dart';

class MyBankPageStyles {
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
  TextStyle formFieldTextStyle;
  TextStyle formFieldHintStyle;
  TextStyle buttonTextStyle;

  double formFieldHeight;
  double borderRadius;
  double iconSize;

  TextStyle linkTextStyle;

  MyBankPageStyles(BuildContext context) {}
}

class MyBankPageMobileStyles extends MyBankPageStyles {
  MyBankPageMobileStyles(BuildContext context) : super(context) {
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

    titleStyle = TextStyle(fontSize: fontSp * 20, color: AppColors.whiteColor, fontFamily: "Exo-SemiBold");
    formFieldTextStyle = TextStyle(fontSize: fontSp * 18, color: Color(0xFF353942));
    formFieldHintStyle = TextStyle(fontSize: fontSp * 16, color: Colors.grey, fontStyle: FontStyle.italic);
    buttonTextStyle = TextStyle(fontSize: fontSp * 18, color: AppColors.whiteColor, fontFamily: "Exo-SemiBold");

    formFieldHeight = widthDp * 35;
    borderRadius = widthDp * 20;
    iconSize = widthDp * 25;

    linkTextStyle = TextStyle(
      color: Color(0xFF1A9EF2),
      fontSize: fontSp * 14.0,
      decorationStyle: TextDecorationStyle.solid,
      decorationColor: Color(0xFF1A9EF2),
      decoration: TextDecoration.underline,
    );
  }
}
