import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../App/index.dart';

class LoginPageStyles {
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

  double logoImageWidth;
  double logoImageHeight;
  double textFieldWidth;
  double textFieldHeight;
  double buttonWidth;
  double buttonheight;
  double iconSize;

  TextStyle titleStyle;
  TextStyle formFieldTextStyle;
  TextStyle formFieldHintStyle;
  TextStyle buttonTextStyle;

  LoginPageStyles(BuildContext context) {}
}

class LoginPageMobileStyles extends LoginPageStyles {
  LoginPageMobileStyles(BuildContext context) : super(context) {
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

    logoImageWidth = widthDp * 200;
    logoImageHeight = widthDp * 200;
    textFieldWidth = widthDp * 300;
    textFieldHeight = widthDp * 40;
    buttonWidth = widthDp * 150;
    buttonheight = widthDp * 40;
    iconSize = widthDp * 20;

    titleStyle = TextStyle(fontSize: fontSp * 35);
    formFieldTextStyle = TextStyle(fontSize: fontSp * 20);
    formFieldHintStyle = TextStyle(fontSize: fontSp * 16, fontStyle: FontStyle.italic, color: Colors.grey);
    buttonTextStyle = TextStyle(fontSize: fontSp * 20, color: AppColors.whiteColor);
  }
}

class LoginPageTabletStyles extends LoginPageStyles {
  LoginPageTabletStyles(BuildContext context) : super(context) {
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

    logoImageWidth = widthDp * 300;
    logoImageHeight = widthDp * 300;
    textFieldWidth = widthDp * 300;
    textFieldHeight = widthDp * 40;
    buttonWidth = widthDp * 150;
    buttonheight = widthDp * 40;
    iconSize = widthDp * 20;

    titleStyle = TextStyle(fontSize: fontSp * 35);
    formFieldTextStyle = TextStyle(fontSize: fontSp * 20);
    formFieldHintStyle = TextStyle(fontSize: fontSp * 16, fontStyle: FontStyle.italic, color: Colors.grey);
    buttonTextStyle = TextStyle(fontSize: fontSp * 20, color: AppColors.whiteColor);
  }
}

class LoginPageDesktopStyles extends LoginPageStyles {
  LoginPageDesktopStyles(BuildContext context) : super(context) {
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

    logoImageWidth = widthDp * 300;
    logoImageHeight = widthDp * 300;
    textFieldWidth = widthDp * 400;
    textFieldHeight = widthDp * 40;
    buttonWidth = widthDp * 150;
    buttonheight = widthDp * 40;
    iconSize = widthDp * 20;

    titleStyle = TextStyle(fontSize: fontSp * 35);
    formFieldTextStyle = TextStyle(fontSize: fontSp * 20);
    formFieldHintStyle = TextStyle(fontSize: fontSp * 16, fontStyle: FontStyle.italic, color: Colors.grey);
    buttonTextStyle = TextStyle(fontSize: fontSp * 20, color: AppColors.whiteColor);
  }
}

class LoginPageLargeDesktopStyles extends LoginPageStyles {
  LoginPageLargeDesktopStyles(BuildContext context) : super(context) {
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

    logoImageWidth = widthDp * 300;
    logoImageHeight = widthDp * 300;
    textFieldWidth = widthDp * 400;
    textFieldHeight = widthDp * 40;
    buttonWidth = widthDp * 150;
    buttonheight = widthDp * 40;
    iconSize = widthDp * 20;

    titleStyle = TextStyle(fontSize: fontSp * 35);
    formFieldTextStyle = TextStyle(fontSize: fontSp * 20);
    formFieldHintStyle = TextStyle(fontSize: fontSp * 16, fontStyle: FontStyle.italic, color: Colors.grey);
    buttonTextStyle = TextStyle(fontSize: fontSp * 20, color: AppColors.whiteColor);
  }
}
