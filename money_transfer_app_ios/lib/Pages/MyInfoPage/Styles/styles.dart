import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:money_transfer_app/Pages/App/index.dart';

class MyInfoPageStyles {
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
  TextStyle detailLabelStyle;
  TextStyle buttonTextStyle;

  double formFieldHeight;
  double borderRadius;
  double iconSize;

  MyInfoPageStyles(BuildContext context) {}
}

class MyInfoPageMobileStyles extends MyInfoPageStyles {
  MyInfoPageMobileStyles(BuildContext context) : super(context) {
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
    formFieldTextStyle = TextStyle(fontSize: fontSp * 14, color: Color(0xFF353942));
    formFieldHintStyle = TextStyle(fontSize: fontSp * 14, color: Colors.grey.withOpacity(0.7), fontStyle: FontStyle.italic);
    detailLabelStyle = TextStyle(fontSize: fontSp * 20, color: Color(0xFF353942), fontFamily: "Exo-SemiBold");
    buttonTextStyle = TextStyle(fontSize: fontSp * 18, color: AppColors.whiteColor, fontFamily: "Exo-SemiBold");

    formFieldHeight = widthDp * 56;
    borderRadius = widthDp * 20;
    iconSize = widthDp * 25;
  }
}
