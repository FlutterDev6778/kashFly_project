import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:money_transfer_app/Pages/App/index.dart';

class CreditCardPageStyles {
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

  double cardHeight;
  double cardHorizontalPadding;
  double cardVerticalPadding;
  double cardBorderRadius;
  double iconSize;

  TextStyle title1Style;
  TextStyle title2Style;
  TextStyle labelTextStyle;
  TextStyle textStyle;
  TextStyle linkStyle;

  double editCardHeight;
  double editCardHorizontalPadding;
  double editCardVerticalPadding;

  TextStyle editCardTitleStyle;
  TextStyle editCardTextStyle;
  TextStyle editCardHintStyle;
  TextStyle editCardButtonStyle;

  CreditCardPageStyles(BuildContext context) {}
}

class CreditCardPageMobileStyles extends CreditCardPageStyles {
  CreditCardPageMobileStyles(BuildContext context) : super(context) {
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

    primaryHorizontalPadding = widthDp * 20;
    primaryVerticalPadding = widthDp * 20;

    cardHeight = widthDp * 50;
    cardHorizontalPadding = widthDp * 20;
    cardVerticalPadding = widthDp * 10;
    cardBorderRadius = widthDp * 10;

    title1Style = TextStyle(fontSize: fontSp * 25, color: AppColors.primaryColor, fontWeight: FontWeight.bold);
    title2Style = TextStyle(fontSize: fontSp * 20, color: AppColors.whiteColor, fontWeight: FontWeight.bold);
    labelTextStyle = new TextStyle(color: AppColors.blackColor, fontSize: fontSp * 16.0);
    textStyle = new TextStyle(color: AppColors.blackColor, fontSize: fontSp * 14.0);
    linkStyle = new TextStyle(color: AppColors.blackColor, fontSize: fontSp * 12.0);

    ///
    ///
    editCardHeight = widthDp * 350;
    editCardHorizontalPadding = widthDp * 15;
    editCardVerticalPadding = widthDp * 15;

    editCardTitleStyle = TextStyle(color: AppColors.blackColor, fontSize: fontSp * 18.0);
    editCardTextStyle = TextStyle(color: AppColors.blackColor, fontSize: fontSp * 14.0);
    editCardHintStyle = TextStyle(color: Colors.grey, fontSize: fontSp * 14.0);
    editCardButtonStyle = TextStyle(color: AppColors.whiteColor, fontSize: fontSp * 16.0);
  }
}
