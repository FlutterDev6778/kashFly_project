import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:money_transfer_app/Pages/App/index.dart';

class ConfirmTransferPageStyles {
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
  double recipientPanelBorderRadius;

  TextStyle title1Style;
  TextStyle title2Style;
  TextStyle userNameStyle;
  TextStyle descriptionStyle;
  TextStyle detailLabelTextStyle;
  TextStyle detailBoldTextStyle;
  TextStyle totalLabeltextStyle;
  TextStyle totalAmounttextStyle;
  TextStyle buttonTextStyle;

  ConfirmTransferPageStyles(BuildContext context) {}
}

class ConfirmTransferPageMobileStyles extends ConfirmTransferPageStyles {
  ConfirmTransferPageMobileStyles(BuildContext context) : super(context) {
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

    historyCardHeight = widthDp * 100;
    historyCardHorizontalPadding = widthDp * 20;
    recipientPanelBorderRadius = widthDp * 20;

    title1Style = TextStyle(fontSize: fontSp * 25, color: AppColors.primaryColor, fontWeight: FontWeight.bold);
    title2Style = TextStyle(fontSize: fontSp * 25, color: AppColors.whiteColor, fontWeight: FontWeight.bold);
    userNameStyle = TextStyle(fontSize: fontSp * 20, color: AppColors.blackColor, fontFamily: "Exo-SemiBold");
    descriptionStyle = TextStyle(fontSize: fontSp * 12, color: Colors.grey);
    detailLabelTextStyle = TextStyle(fontSize: fontSp * 14, color: AppColors.secondaryColor, fontWeight: FontWeight.bold);
    detailBoldTextStyle = TextStyle(fontSize: fontSp * 14, color: AppColors.blackColor, fontWeight: FontWeight.bold);
    totalLabeltextStyle = TextStyle(fontSize: fontSp * 14, color: AppColors.whiteColor);
    totalAmounttextStyle = TextStyle(fontSize: fontSp * 24, color: AppColors.whiteColor, fontWeight: FontWeight.bold);
    buttonTextStyle = TextStyle(fontSize: fontSp * 18, color: AppColors.whiteColor, fontFamily: "Exo-SemiBold");
  }
}
