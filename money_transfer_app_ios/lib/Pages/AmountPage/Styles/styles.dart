import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:money_transfer_app/Pages/App/index.dart';

class AmountPageStyles {
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

  double historyCardHeight;
  double historyCardHorizontalPadding;

  TextStyle title1Style;
  TextStyle title2Style;
  TextStyle labelStyle;
  TextStyle amountTextStyle;
  TextStyle textStyle;
  TextStyle buttonTextStyle;
  TextStyle limitErrorTextStyle;
  TextStyle limitTextStyle;

  AmountPageStyles(BuildContext context) {}
}

class AmountPageMobileStyles extends AmountPageStyles {
  AmountPageMobileStyles(BuildContext context) : super(context) {
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

    primaryHorizontalPadding = widthDp * 30;
    primaryVerticalPadding = widthDp * 30;

    historyCardHeight = widthDp * 100;
    historyCardHorizontalPadding = widthDp * 20;

    title1Style = TextStyle(fontSize: fontSp * 25, color: AppColors.primaryColor, fontWeight: FontWeight.bold);
    title2Style = TextStyle(fontSize: fontSp * 25, color: AppColors.whiteColor, fontWeight: FontWeight.bold);
    labelStyle = TextStyle(fontSize: fontSp * 15, color: Colors.grey);
    amountTextStyle = TextStyle(
      fontSize: fontSp * 60,
      color: AppColors.whiteColor,
      fontFamily: "Exo-SemiBold",
    );
    textStyle = TextStyle(fontSize: fontSp * 15, color: AppColors.blackColor);
    buttonTextStyle = TextStyle(fontSize: fontSp * 18, color: AppColors.whiteColor);

    limitTextStyle = TextStyle(fontSize: fontSp * 13, color: Colors.white, fontWeight: FontWeight.bold);
    limitErrorTextStyle = TextStyle(fontSize: fontSp * 13, color: Colors.limeAccent, fontWeight: FontWeight.bold);
  }
}
