import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:money_transfer_app/Pages/App/index.dart';

class HomePageStyles {
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

  TextStyle titleStyle;
  TextStyle labelStyle;
  TextStyle feeTextStyle;
  TextStyle limitTextStyle;
  TextStyle birthDayStyle;

  ///

  double historyCardHeight;
  double historyCardHorizontalPadding;

  TextStyle headerStyle;
  TextStyle textStyle;

  TextStyle amountStyle;
  TextStyle pendingStyle;
  TextStyle sentStyle;

  HomePageStyles(BuildContext context) {}
}

class HomePageMobileStyles extends HomePageStyles {
  HomePageMobileStyles(BuildContext context) : super(context) {
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

    primaryHorizontalPadding = widthDp * 20;
    primaryVerticalPadding = widthDp * 20;

    titleStyle = TextStyle(fontSize: fontSp * 20, color: AppColors.whiteColor, fontFamily: "Exo-SemiBold");
    labelStyle = TextStyle(fontSize: fontSp * 18, color: AppColors.blackColor, fontWeight: FontWeight.w600);
    feeTextStyle = TextStyle(fontSize: fontSp * 14, color: Color(0xFF353942), fontWeight: FontWeight.w500);
    limitTextStyle = TextStyle(fontSize: fontSp * 12, color: Color(0xFF353942), fontWeight: FontWeight.w600);

    ///

    historyCardHeight = widthDp * 100;
    historyCardHorizontalPadding = widthDp * 20;

    textStyle = TextStyle(fontSize: fontSp * 18, color: AppColors.blackColor);
    headerStyle = TextStyle(fontSize: fontSp * 18, color: Colors.grey);

    amountStyle = TextStyle(fontSize: fontSp * 17, color: AppColors.blackColor, fontFamily: "Exo-SemiBold");
    pendingStyle = TextStyle(fontSize: fontSp * 12, color: Color(0xFFF7A000), fontFamily: "Exo-SemiBold");
    sentStyle = TextStyle(fontSize: fontSp * 12, color: Color(0xFF41D7BD), fontFamily: "Exo-SemiBold");
    birthDayStyle = TextStyle(fontSize: fontSp * 12, color: AppColors.blackColor, fontFamily: "Exo-Medium");
  }
}
