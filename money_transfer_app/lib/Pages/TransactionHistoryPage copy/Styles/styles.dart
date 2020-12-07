import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:money_transfer_app/Pages/App/index.dart';

class TransactionHistoryPageStyles {
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
  TextStyle tabItemStyle;
  TextStyle labelStyle;
  TextStyle textStyle;
  TextStyle amountStyle;

  TransactionHistoryPageStyles(BuildContext context) {}
}

class TransactionHistoryPageMobileStyles extends TransactionHistoryPageStyles {
  TransactionHistoryPageMobileStyles(BuildContext context) : super(context) {
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
    primaryVerticalPadding = widthDp * 30;

    historyCardHeight = widthDp * 100;
    historyCardHorizontalPadding = widthDp * 20;

    title1Style = TextStyle(fontSize: fontSp * 25, color: AppColors.primaryColor, fontWeight: FontWeight.bold);
    title2Style = TextStyle(fontSize: fontSp * 25, color: AppColors.whiteColor, fontWeight: FontWeight.bold);
    tabItemStyle = TextStyle(fontSize: fontSp * 20, color: AppColors.whiteColor, fontFamily: "Comfortaa");
    labelStyle = TextStyle(fontSize: fontSp * 15, color: Colors.grey);
    textStyle = TextStyle(fontSize: fontSp * 15, color: AppColors.blackColor);
    amountStyle = TextStyle(fontSize: fontSp * 17, color: AppColors.blackColor, fontWeight: FontWeight.bold);
  }
}
