import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../App/index.dart';

class ConfigurationPageStyles {
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

  int columnCount;
  double cardHorizontalPadding;
  double cardVerticalPadding;
  double cardHorizontalMargin;
  double cardVerticalMargin;

  double rowHeight;

  TextStyle tableLabelStyle;
  TextStyle tableHeaderStyle;
  TextStyle tableCellStyle;

  double buttonWidth;
  double buttonHeiht;
  TextStyle buttonTextStyle;
  double editIconSize;

  ConfigurationPageStyles(BuildContext context) {}
}

class ConfigurationPageMobileStyles extends ConfigurationPageStyles {
  ConfigurationPageMobileStyles(BuildContext context) : super(context) {
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
    mainHeight = deviceHeight - bottombarHeight;

    primaryHorizontalPadding = widthDp * 20;
    primaryVerticalPadding = widthDp * 20;

    columnCount = 1;
    cardHorizontalPadding = widthDp * 20;
    cardVerticalPadding = widthDp * 20;
    cardHorizontalMargin = widthDp * 15;
    cardVerticalMargin = widthDp * 15;

    rowHeight = widthDp * 40;

    tableLabelStyle = TextStyle(fontSize: fontSp * 20, color: AppColors.blackColor);
    tableHeaderStyle = TextStyle(fontSize: fontSp * 16, color: AppColors.whiteColor);
    tableCellStyle = TextStyle(fontSize: fontSp * 16, color: AppColors.blackColor);

    buttonWidth = widthDp * 100;
    buttonHeiht = widthDp * 30;
    buttonTextStyle = TextStyle(fontSize: fontSp * 16, color: AppColors.whiteColor);
    editIconSize = widthDp * 20;
  }
}

class ConfigurationPageTabletStyles extends ConfigurationPageStyles {
  ConfigurationPageTabletStyles(BuildContext context) : super(context) {
    ScreenUtil.init(
      context,
      width: ResponsiveDesignSettings.tabletDesignWidth,
      height: ResponsiveDesignSettings.tabletDesignHeight,
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
    mainHeight = deviceHeight - bottombarHeight;

    primaryHorizontalPadding = widthDp * 20;
    primaryVerticalPadding = widthDp * 20;

    columnCount = 2;
    cardHorizontalPadding = widthDp * 20;
    cardVerticalPadding = widthDp * 20;
    cardHorizontalMargin = widthDp * 15;
    cardVerticalMargin = widthDp * 15;

    rowHeight = widthDp * 40;

    tableLabelStyle = TextStyle(fontSize: fontSp * 20, color: AppColors.blackColor);
    tableHeaderStyle = TextStyle(fontSize: fontSp * 16, color: AppColors.whiteColor);
    tableCellStyle = TextStyle(fontSize: fontSp * 16, color: AppColors.blackColor);

    buttonWidth = widthDp * 100;
    buttonHeiht = widthDp * 30;
    buttonTextStyle = TextStyle(fontSize: fontSp * 16, color: AppColors.whiteColor);
    editIconSize = widthDp * 20;
  }
}

class ConfigurationPageDesktopStyles extends ConfigurationPageStyles {
  ConfigurationPageDesktopStyles(BuildContext context) : super(context) {
    ScreenUtil.init(
      context,
      width: ResponsiveDesignSettings.desktopDesignWidth,
      height: ResponsiveDesignSettings.desktopDesignWidth,
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
    widthDp = 1;
    heightDp = 1;
    fontSp = 1;
    mainHeight = deviceHeight - bottombarHeight;

    primaryHorizontalPadding = widthDp * 20;
    primaryVerticalPadding = widthDp * 20;

    columnCount = 2;
    cardHorizontalPadding = widthDp * 20;
    cardVerticalPadding = widthDp * 20;
    cardHorizontalMargin = widthDp * 15;
    cardVerticalMargin = widthDp * 15;

    rowHeight = widthDp * 40;

    tableLabelStyle = TextStyle(fontSize: fontSp * 20, color: AppColors.blackColor);
    tableHeaderStyle = TextStyle(fontSize: fontSp * 16, color: AppColors.whiteColor);
    tableCellStyle = TextStyle(fontSize: fontSp * 16, color: AppColors.blackColor);

    buttonWidth = widthDp * 100;
    buttonHeiht = widthDp * 30;
    buttonTextStyle = TextStyle(fontSize: fontSp * 16, color: AppColors.whiteColor);
    editIconSize = widthDp * 20;
  }
}

class ConfigurationPageLargeDesktopStyles extends ConfigurationPageStyles {
  ConfigurationPageLargeDesktopStyles(BuildContext context) : super(context) {
    ScreenUtil.init(
      context,
      width: ResponsiveDesignSettings.largeDesktopDesignWidth,
      height: ResponsiveDesignSettings.largeDesktopDesignHeight,
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
    mainHeight = deviceHeight - bottombarHeight;

    primaryHorizontalPadding = widthDp * 20;
    primaryVerticalPadding = widthDp * 20;

    columnCount = 2;
    cardHorizontalPadding = widthDp * 20;
    cardVerticalPadding = widthDp * 20;
    cardHorizontalMargin = widthDp * 15;
    cardVerticalMargin = widthDp * 15;

    rowHeight = widthDp * 40;

    tableLabelStyle = TextStyle(fontSize: fontSp * 20, color: AppColors.blackColor);
    tableHeaderStyle = TextStyle(fontSize: fontSp * 16, color: AppColors.whiteColor);
    tableCellStyle = TextStyle(fontSize: fontSp * 16, color: AppColors.blackColor);

    buttonWidth = widthDp * 100;
    buttonHeiht = widthDp * 30;
    buttonTextStyle = TextStyle(fontSize: fontSp * 16, color: AppColors.whiteColor);
    editIconSize = widthDp * 20;
  }
}
